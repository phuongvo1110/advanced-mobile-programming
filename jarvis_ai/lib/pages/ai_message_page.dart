import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jarvis_ai/models/conversation.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';
import 'package:mobx/mobx.dart';

class IdOption {
  final Id value;
  final String label;
  const IdOption({required this.value, required this.label});
}

const List<IdOption> idOptions = [
  IdOption(value: Id.CLAUDE_3_HAIKU_20240307, label: 'Claude 3 Haiku'),
  IdOption(value: Id.CLAUDE_3_SONNET_20240229, label: 'Claude 3 Sonnet'),
  IdOption(value: Id.GEMINI_15_FLASH_LATEST, label: 'Gemini 1.5 Flash'),
  IdOption(value: Id.GEMINI_15_PRO_LATEST, label: 'Gemini 1.5 Pro'),
  IdOption(value: Id.GPT_4_O, label: 'GPT-4o'),
  IdOption(value: Id.GPT_4_O_MINI, label: 'GPT-4o Mini'),
];

class AIChatMessageModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(String?)? textControllerValidator;
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

class AIMessagePage extends StatefulWidget {
  const AIMessagePage({super.key, required this.apiStore});
  final ApiStore apiStore;
  @override
  State<AIMessagePage> createState() => _AIMessagePageWidgetState();
}

class _AIMessagePageWidgetState extends State<AIMessagePage> {
  late AIChatMessageModel _model;
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> conversationHistory = [];
  ObservableList<Message> messages = ObservableList<Message>();
  bool isLoading = false;
  IdOption selectedBot = idOptions.firstWhere(
    (option) => option.value == Id.GPT_4_O_MINI,
  );

  // Assistant details - these could also be passed as parameters
  Assistant get currentAssistant => Assistant(
    id: selectedBot.value,
    model: Model.DIFY,
    name: selectedBot.label,
  );
  @override
  void initState() {
    super.initState();
    _model = AIChatMessageModel();

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  Future<void> _sendMessage() async {
    final text = _model.textController?.text.trim();
    if (text == null || text.isEmpty) return;
    setState(() {
      isLoading = true;
      messages.add(
        Message(assistant: currentAssistant, content: text, role: 'user'),
      );
      _model.textController?.clear();
    });

    _scrollToBottom();
    try {
      final response = await widget.apiStore.jarvisService.sendMessage(
        content: text,
        assistant: currentAssistant,
        conversationHistory: conversationHistory,
      );
      setState(() {
        final modelResponse = Message(
          assistant: currentAssistant,
          content: response ?? '',
          role: 'model',
        );
        messages.add(modelResponse);
        conversationHistory.addAll([
          messages[messages.length - 2].toJson(),
          modelResponse.toJson(),
        ]);
      });
    } catch (e) {
      setState(() {
        messages.add(
          Message(
            assistant: currentAssistant,
            content: 'Sorry, I encountered an error. Please try again.',
            role: 'model',
          ),
        );
      });
    } finally {
      setState(() => isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JarvisTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: JarvisTheme.of(context).secondary,
        automaticallyImplyLeading: false,
        leading: JarvisIconButton(
          borderRadius: 8.0,
          buttonSize: 40.0,
          fillColor: JarvisTheme.of(context).secondary,
          icon: Icon(
            Icons.arrow_back,
            color: JarvisTheme.of(context).info,
            size: 24.0,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        title: Text(
          'Jarvis.AI',
          style: JarvisTheme.of(context).displaySmall.override(
            fontFamily: 'Poppins',
            color: JarvisTheme.of(context).primaryText,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: JarvisTheme.of(context).secondaryText,
                offset: Offset(2.0, 2.0),
                blurRadius: 2.0,
              ),
            ],
          ),
        ),
        actions: [
          DropdownButton(
            value: selectedBot,
            icon: Icon(
              Icons.arrow_drop_down,
              color: JarvisTheme.of(context).info,
            ),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: JarvisTheme.of(context).primaryText,
              fontWeight: FontWeight.w900,
            ),
            underline: Container(height: 0),
            dropdownColor: JarvisTheme.of(context).secondaryBackground,
            items:
                idOptions.map<DropdownMenuItem<IdOption>>((IdOption option) {
                  return DropdownMenuItem<IdOption>(
                    value: option,
                    child: Text(
                      option.label,
                      style: JarvisTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: JarvisTheme.of(context).primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (IdOption? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedBot = newValue;
                  messages.clear();
                  conversationHistory.clear();
                });
              }
            },
          ),
          // Padding(
          //   padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
          //   child: JarvisIconButton(
          //     borderColor: Colors.transparent,
          //     borderRadius: 30.0,
          //     borderWidth: 1.0,
          //     buttonSize: 60.0,
          //     icon: FaIcon(
          //       FontAwesomeIcons.solidCircleUser,
          //       color: JarvisTheme.of(context).primaryText,
          //       size: 30.0,
          //     ),
          //     onPressed: () async {},
          //   ),
          // ),
        ],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 80.0),
                  child: Observer(
                    builder: (context) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return _buildMessageBubble(message);
                        },
                      );
                    },
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Container(
                    width: double.infinity,
                    height: 32.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          JarvisTheme.of(context).primaryBackground,
                          JarvisTheme.of(context).primaryBackground,
                        ],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(0.0, 1.0),
                        end: AlignmentDirectional(0, -1.0),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Container(
                    width: double.infinity,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: JarvisTheme.of(context).secondaryBackground,
                      border: Border.all(
                        color: JarvisTheme.of(context).alternate,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        16.0,
                        12.0,
                        16.0,
                        12.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              autofocus: false,
                              textCapitalization: TextCapitalization.sentences,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                hintStyle: JarvisTheme.of(
                                  context,
                                ).labelMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 0.0,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 0.0,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 0.0,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 0.0,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                filled: true,
                                fillColor:
                                    JarvisTheme.of(context).primaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  16.0,
                                  12.0,
                                  16.0,
                                  12.0,
                                ),
                              ),
                              style: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                letterSpacing: 0.0,
                              ),
                              cursorColor: JarvisTheme.of(context).primary,
                              validator: _model.textControllerValidator,
                            ),
                          ),
                          SizedBox(width: 12.0),
                          JarvisIconButton(
                            borderRadius: 24.0,
                            buttonSize: 48.0,
                            fillColor: JarvisTheme.of(context).secondary,
                            icon: Icon(
                              Icons.send_rounded,
                              color: JarvisTheme.of(context).info,
                              size: 24.0,
                            ),
                            onPressed: _sendMessage,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isUser = message.role == 'user';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color:
                isUser
                    ? JarvisTheme.of(context).secondary
                    : JarvisTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isUser)
                  Text(
                    message.assistant.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: JarvisTheme.of(context).primaryText,
                    ),
                  ),
                SizedBox(height: 4),
                Text(
                  message.content,
                  style: JarvisTheme.of(context).bodyMedium.copyWith(
                    color:
                        isUser
                            ? JarvisTheme.of(context).info
                            : JarvisTheme.of(context).primaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
