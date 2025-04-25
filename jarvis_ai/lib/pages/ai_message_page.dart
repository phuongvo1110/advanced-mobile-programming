import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jarvis_ai/models/conversation.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';
import 'package:mobx/mobx.dart';
import 'package:jarvis_ai/models/assistant.dart';

class AssistantOption {
  final String value; // ID for custom assistants, model for predefined
  final String label;
  final bool isCustom; // True for custom assistants, false for predefined
  final String model; // 'knowledge-base' for custom, model ID for predefined

  const AssistantOption({
    required this.value,
    required this.label,
    required this.isCustom,
    required this.model,
  });
}

const List<AssistantOption> predefinedOptions = [
  AssistantOption(
    value: 'claude-3-haiku-20240307',
    label: 'Claude 3 Haiku',
    isCustom: false,
    model: 'claude-3-haiku-20240307',
  ),
  AssistantOption(
    value: 'claude-3-5-sonnet-20240620',
    label: 'Claude 3 Sonnet',
    isCustom: false,
    model: 'claude-3-5-sonnet-20240620',
  ),
  AssistantOption(
    value: 'gemini-1.5-flash-latest',
    label: 'Gemini 1.5 Flash',
    isCustom: false,
    model: 'gemini-1.5-flash-latest',
  ),
  AssistantOption(
    value: 'gemini-1.5-pro-latest',
    label: 'Gemini 1.5 Pro',
    isCustom: false,
    model: 'gemini-1.5-pro-latest',
  ),
  AssistantOption(
    value: 'gpt-4o',
    label: 'GPT-4o',
    isCustom: false,
    model: 'gpt-4o',
  ),
  AssistantOption(
    value: 'gpt-4o-mini',
    label: 'GPT-4o Mini',
    isCustom: false,
    model: 'gpt-4o-mini',
  ),
];

class AIChatMessageModel {
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(String?)? textControllerValidator;
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

class AIMessagePage extends StatefulWidget {
  const AIMessagePage({super.key, required this.apiStore, this.assistantId});
  final ApiStore apiStore;
  final String? assistantId;

  @override
  State<AIMessagePage> createState() => _AIMessagePageWidgetState();
}

class _AIMessagePageWidgetState extends State<AIMessagePage> {
  late AIChatMessageModel _model;
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> conversationHistory = [];
  ObservableList<Message> messages = ObservableList<Message>();
  bool isLoading = false;
  AssistantOption? selectedAssistantOption;
  List<AssistantOption> assistantOptions = [];
  Assistant? currentAssistant;

  @override
  void initState() {
    super.initState();
    _model = AIChatMessageModel();
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _loadAssistants();
  }

  Future<void> _loadAssistants() async {
    setState(() => isLoading = true);
    try {
      await widget.apiStore.kbService.getAssistants();
      setState(() {
        assistantOptions = [
          ...predefinedOptions,
          ...widget.apiStore.kbService.assistants.map(
            (assistant) => AssistantOption(
              value: assistant.id,
              label: assistant.assistantName,
              isCustom: true,
              model: 'knowledge-base',
            ),
          ),
        ];
        if (widget.assistantId != null) {
          _loadAssistantAndHistory();
        } else {
          selectedAssistantOption = assistantOptions.firstWhere(
            (option) => option.value == 'gpt-4o-mini',
            orElse: () => assistantOptions.first,
          );
          currentAssistant = Assistant(
            id: selectedAssistantOption!.value,
            model: selectedAssistantOption!.model,
            name: selectedAssistantOption!.label,
          );
          _loadConversationHistory();
        }
      });
    } catch (e) {
      print('Error loading assistants: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load assistants')));
      // Fallback to predefined options if fetching fails
      setState(() {
        assistantOptions = predefinedOptions;
        selectedAssistantOption = assistantOptions.firstWhere(
          (option) => option.value == 'gpt-4o-mini',
          orElse: () => assistantOptions.first,
        );
        currentAssistant = Assistant(
          id: selectedAssistantOption!.value,
          model: selectedAssistantOption!.model,
          name: selectedAssistantOption!.label,
        );
        _loadConversationHistory();
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadAssistantAndHistory() async {
    if (widget.assistantId == null) return;

    setState(() => isLoading = true);
    try {
      final assistantDetail = await widget.apiStore.kbService.getAssistantById(
        id: widget.assistantId!,
      );
      if (assistantDetail != null) {
        setState(() {
          currentAssistant = Assistant(
            id: assistantDetail.id,
            model: 'knowledge-base',
            name: assistantDetail.assistantName,
          );
          selectedAssistantOption = assistantOptions.firstWhere(
            (option) => option.value == assistantDetail.id,
            orElse:
                () => AssistantOption(
                  value: assistantDetail.id,
                  label: assistantDetail.assistantName,
                  isCustom: true,
                  model: 'knowledge-base',
                ),
          );
        });
        await _loadConversationHistory();
      }
    } catch (e) {
      print('Error loading assistant: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load assistant')));
      // Fallback to default predefined bot if loading fails
      setState(() {
        selectedAssistantOption = assistantOptions.firstWhere(
          (option) => option.value == 'gpt-4o-mini',
          orElse: () => assistantOptions.first,
        );
        currentAssistant = Assistant(
          id: selectedAssistantOption!.value,
          model: selectedAssistantOption!.model,
          name: selectedAssistantOption!.label,
        );
        _loadConversationHistory();
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadConversationHistory() async {
    if (currentAssistant == null) return;

    setState(() => isLoading = true);
    try {
      final history = await widget.apiStore.jarvisService
          .getConversationHistory(
            conversationId: currentAssistant!.id as String,
            assistantModel: currentAssistant!.model,
          );

      setState(() {
        messages.clear();
        conversationHistory.clear();
        if (history != null && history.isNotEmpty) {
          messages.addAll(history);
          conversationHistory = history.map((m) => m.toJson()).toList();
        }
      });
    } catch (e) {
      print('Error loading conversation history: $e');
      setState(() {
        messages.clear();
        conversationHistory.clear();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Starting a new conversation')));
    } finally {
      setState(() => isLoading = false);
      _scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    final text = _model.textController?.text.trim();
    if (text == null || text.isEmpty || currentAssistant == null) return;

    setState(() {
      isLoading = true;
      messages.add(
        Message(assistant: currentAssistant!, content: text, role: 'user'),
      );
      _model.textController?.clear();
    });

    _scrollToBottom();
    try {
      final response = await widget.apiStore.jarvisService.sendMessage(
        content: text,
        assistant: currentAssistant!,
        conversationHistory: conversationHistory,
      );
      setState(() {
        final modelResponse = Message(
          assistant: currentAssistant!,
          content: response ?? 'No response received',
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
            assistant: currentAssistant!,
            content: 'Sorry, I encountered an error. Please try again.',
            role: 'model',
          ),
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: ${e.toString()}')),
      );
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
    _scrollController.dispose();
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
            Navigator.pushNamed(context, '/bots');
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
          DropdownButton<AssistantOption>(
            value: selectedAssistantOption,
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
                assistantOptions.map<DropdownMenuItem<AssistantOption>>((
                  AssistantOption option,
                ) {
                  return DropdownMenuItem<AssistantOption>(
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
            onChanged: (AssistantOption? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedAssistantOption = newValue;
                  currentAssistant = Assistant(
                    id: newValue.value,
                    model: newValue.model,
                    name: newValue.label,
                  );
                  messages.clear();
                  conversationHistory.clear();
                  _loadConversationHistory();
                });
              }
            },
          ),
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
                      if (isLoading && messages.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      }
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
                              enabled: !isLoading,
                              onFieldSubmitted: (_) => _sendMessage(),
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
                            onPressed: isLoading ? null : _sendMessage,
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
