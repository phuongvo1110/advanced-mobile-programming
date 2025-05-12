import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jarvis_ai/models/conversation.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';
import 'package:mobx/mobx.dart';

class EmailGeneratorPage extends StatefulWidget {
  const EmailGeneratorPage({super.key, required this.apiStore});
  final ApiStore apiStore;

  @override
  State<EmailGeneratorPage> createState() => _EmailGeneratorPageState();
}

class _EmailGeneratorPageState extends State<EmailGeneratorPage>
    with SingleTickerProviderStateMixin {
  late AIChatMessageModel _model;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ObservableList<Message> messages = ObservableList<Message>();
  ObservableList<String> improvedActions = ObservableList<String>();
  GlobalKey textFieldKey = GlobalKey();
  bool isLoading = false;
  Assistant currentAssistant = Assistant(
    id: 'gpt-4o-mini',
    model: 'dify',
    name: 'GPT-4o Mini',
  );
  final List<String> _tabs = ['Replying to Email', 'Composing New Email'];

  // Fields for Replying to Email tab
  final TextEditingController _replyActionController = TextEditingController();
  final TextEditingController _replyToController = TextEditingController();
  final TextEditingController _replySubjectController = TextEditingController();
  final TextEditingController _replySenderController = TextEditingController();

  final TextEditingController _replyEmailContentController =
      TextEditingController();
  String? _replyActionError;
  String? _replyToError;
  String? _replySubjectError;
  String? _replySenderError;
  String? _replyEmailContentError;
  // Fields for Composing New Email tab
  final TextEditingController _composeToController = TextEditingController();
  final TextEditingController _composeMainIdeaController =
      TextEditingController();
  final TextEditingController _composeActionController =
      TextEditingController();

  final TextEditingController _composeSubjectController =
      TextEditingController();
  final TextEditingController _composeSenderController =
      TextEditingController();
  final TextEditingController _composeBodyController = TextEditingController();
  String? _composeMainIdeaError;
  String? _composeActionError;
  String? _composeToError;
  String? _composeSubjectError;
  String? _composeSenderError;
  String? _composeBodyError;
  String _tone = 'Friendly';
  String _language = 'US English';
  String _selectedLength = 'Long';
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'This field cannot be empty';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value))
      return 'Please enter a valid email address';
    return null;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) return 'This field cannot be empty';
    return null;
  }

  String? _validateContent(String? value) {
    if (value == null || value.isEmpty) return 'Please provide some content';
    return null;
  }

  @override
  void initState() {
    super.initState();
    _model = AIChatMessageModel();
    _model.initState(context);
    _tabController = TabController(length: _tabs.length, vsync: this);
    _model.textController!.addListener(_handleTextChange);

    // Add listener to TabController to rebuild UI when tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {}); // Trigger rebuild when tab changes
      // Close the drawer if it's open when switching tabs
      if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
        _scaffoldKey.currentState?.closeEndDrawer();
      }
    });
  }

  void _handleTextChange() {
    // Handle text change if needed
  }

  Future<void> _sendMessage() async {
    final text = _model.textController!.text.trim();
    if (text.isEmpty) return;

    setState(() {
      isLoading = true;
      messages.add(
        Message(assistant: currentAssistant, content: text, role: 'user'),
      );
      _model.textController!.clear();
    });

    try {
      if (_tabController.index == 0) {
        // Replying to Email tab
        final response = await _generateEmailReply(text);
        messages.add(
          Message(
            assistant: currentAssistant,
            content: response,
            role: 'model',
          ),
        );
      } else {
        // Composing New Email tab
        final response = await _composeNewEmail(text);
        messages.add(
          Message(
            assistant: currentAssistant,
            content: response,
            role: 'model',
          ),
        );
      }
    } catch (e) {
      messages.add(
        Message(
          assistant: currentAssistant,
          content: 'Error generating email. Please try again.',
          role: 'model',
        ),
      );
    } finally {
      setState(() => isLoading = false);
      _scrollToBottom();
    }
  }

  Future<void> _generateReplyFromDrawer() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await widget.apiStore.jarvisService.responseEmail(
        mainIdea: 'Confirm attendance and express interest in the event',
        action: 'Reply to this email',
        email: _replyEmailContentController.text,
        subject: _replySubjectController.text,
        sender: 'User',
        receiver: _replyToController.text,
      );
      messages.add(
        Message(
          assistant: currentAssistant,
          content: response?.email ?? 'No response received',
          role: 'model',
        ),
      );
    } catch (e) {
      messages.add(
        Message(
          assistant: currentAssistant,
          content: 'Error generating email reply. Please try again.',
          role: 'model',
        ),
      );
    } finally {
      setState(() => isLoading = false);
      _scrollToBottom();
      _scaffoldKey.currentState?.closeEndDrawer();
    }
  }

  Future<void> _suggestReplyIdeasFromDrawer() async {
    setState(() {
      isLoading = true;
    });

    try {
      final ideas = await widget.apiStore.jarvisService.suggestReplyIdea(
        action: _replyActionController.text,
        email: _replyEmailContentController.text,
        subject: _replySubjectController.text,
        sender: _replySenderController.text,
        receiver: _replyToController.text,
      );
      messages.add(
        Message(
          assistant: currentAssistant,
          content:
              'Suggested Reply Ideas:\n${ideas?.join('\n') ?? 'No ideas received'}',
          role: 'model',
        ),
      );
    } catch (e) {
      messages.add(
        Message(
          assistant: currentAssistant,
          content: 'Error suggesting reply ideas. Please try again.',
          role: 'model',
        ),
      );
    } finally {
      setState(() => isLoading = false);
      _scrollToBottom();
      _scaffoldKey.currentState?.closeEndDrawer();
    }
  }

  Future<void> _generateEmailFromDrawer() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await widget.apiStore.jarvisService.responseEmail(
        mainIdea: _composeMainIdeaController.text,
        action: _composeActionController.text,
        email: _composeBodyController.text,
        subject: _composeSubjectController.text,
        sender:
            _composeSenderController
                .text, // Replace with actual sender if available
        receiver: _composeToController.text,
        language: _language,
        tone: _tone,
        length: _selectedLength,
      );
      if (response != null) {
        messages.add(
          Message(
            assistant: currentAssistant,
            content: response.email ?? 'No response received',
            role: 'model',
          ),
        );
        if (response.improvedActions != null) {
          improvedActions.clear();
          improvedActions.addAll(response.improvedActions!);
        }
      }
    } catch (e) {
      messages.add(
        Message(
          assistant: currentAssistant,
          content: 'Error generating email. Please try again.',
          role: 'model',
        ),
      );
    } finally {
      setState(() => isLoading = false);
      _scrollToBottom();
      _scaffoldKey.currentState?.closeEndDrawer();
    }
  }

  Future<String> _generateEmailReply(String description) async {
    final response = await widget.apiStore.jarvisService.sendMessage(
      content: jsonEncode({
        "action": description,
        "email": _replyEmailContentController.text,
        "metadata": {
          "context": [],
          "subject": _replySubjectController.text,
          "sender": "User",
          "receiver": _replyToController.text,
          "language": "vietnamese",
        },
      }),
      assistant: currentAssistant,
    );
    return response?.message ?? 'No response received';
  }

  Future<String> _composeNewEmail(String description) async {
    final response = await widget.apiStore.jarvisService.sendMessage(
      content: jsonEncode({
        "mainIdea": description,
        "action": _composeActionController.text,
        "metadata": {
          "context": [],
          "subject": _composeSubjectController.text,
          "receiver": _composeToController.text,
          "body": _composeBodyController.text,
          "style": {
            "length": _selectedLength,
            "formality": "neutral",
            "tone": _tone,
          },
          "language": _language,
        },
      }),
      assistant: currentAssistant,
    );
    return response?.message ?? 'No response received';
  }

  Future<List<String>> _suggestReplyIdeas() async {
    final response = await widget.apiStore.jarvisService.sendMessage(
      content: jsonEncode({
        "action": "Suggest 3 ideas for this email",
        "email": _replyEmailContentController.text,
        "metadata": {
          "context": [],
          "subject": _replySubjectController.text,
          "sender": "User",
          "receiver": _replyToController.text,
          "language": "vietnamese",
        },
      }),
      assistant: currentAssistant,
    );
    return (response?.message?.split('\n') ?? ['Idea 1', 'Idea 2', 'Idea 3']);
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
    _tabController.dispose();
    _replyToController.dispose();
    _replyActionController.dispose();
    _replySenderController.dispose();
    _replySubjectController.dispose();
    _replyEmailContentController.dispose();
    _composeToController.dispose();
    _composeSubjectController.dispose();
    _composeBodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = JarvisTheme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: theme.secondary,
        title: Text(
          'Email Generator',
          style: theme.displaySmall.override(
            fontFamily: 'Poppins',
            color: theme.primaryText,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.info),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: theme.info),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          labelColor: theme.primaryText,
          unselectedLabelColor: theme.secondaryText,
          indicatorColor: theme.primary,
        ),
      ),
      endDrawer: Drawer(
        width: 400,
        child: Form(
          key: _formKey, // Attach form key
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tabController.index == 0
                      ? 'Reply to Email'
                      : 'Response Email',
                  style: theme.titleLarge,
                ),
                SizedBox(height: 20),
                if (_tabController.index == 0) ...[
                  TextFormField(
                    controller: _replyActionController,
                    decoration: InputDecoration(
                      labelText: 'Action',
                      border: OutlineInputBorder(),
                      errorText: _replyActionError,
                    ),
                    validator: _validateRequired,
                    onChanged: (value) {
                      setState(() {
                        _replyActionError = _validateRequired(value);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _replySenderController,
                    decoration: InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                      errorText: _replySenderError,
                    ),
                    validator: _validateEmail,
                    onChanged: (value) {
                      setState(() {
                        _replySenderError = _validateEmail(value);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _replyToController,
                    decoration: InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                      errorText: _replyToError,
                    ),
                    validator: _validateEmail,
                    onChanged: (value) {
                      setState(() {
                        _replyToError = _validateEmail(value);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _replySubjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                      errorText: _replySubjectError,
                    ),
                    validator: _validateRequired,
                    onChanged: (value) {
                      setState(() {
                        _replySubjectError = _validateRequired(value);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _replyEmailContentController,
                      decoration: InputDecoration(
                        labelText: 'Email Content',
                        border: OutlineInputBorder(),
                        errorText: _replyEmailContentError,
                      ),
                      validator: _validateContent,
                      onChanged: (value) {
                        setState(() {
                          _replyEmailContentError = _validateContent(value);
                        });
                      },
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    _suggestReplyIdeasFromDrawer();
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.secondary,
                          foregroundColor: theme.primaryText,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Suggest Reply Ideas',
                          style: theme.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  TextFormField(
                    controller: _composeMainIdeaController,
                    decoration: InputDecoration(
                      labelText: 'Idea',
                      border: OutlineInputBorder(),
                      errorText: _composeMainIdeaError,
                    ),
                    validator: _validateRequired,
                    onChanged: (value) {
                      setState(() {
                        _composeMainIdeaError = _validateRequired(value);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _composeActionController,
                    decoration: InputDecoration(
                      labelText: 'Action',
                      border: OutlineInputBorder(),
                      errorText: _composeActionError,
                    ),
                    validator: _validateRequired,
                    onChanged: (value) {
                      setState(() {
                        _composeActionError = _validateRequired(value);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _composeSenderController,
                    decoration: InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                      errorText: _composeSenderError,
                    ),
                    validator: _validateEmail,
                    onChanged: (value) {
                      setState(() {
                        _composeSenderError = _validateEmail(value);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _composeToController,
                    decoration: InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                      errorText: _composeToError,
                    ),
                    validator: _validateEmail,
                    onChanged: (value) {
                      setState(() {
                        _composeToError = _validateEmail(value);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _composeSubjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                      errorText: _composeSubjectError,
                    ),
                    validator: _validateRequired,
                    onChanged: (value) {
                      setState(() {
                        _composeSubjectError = _validateRequired(value);
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _composeBodyController,
                      decoration: InputDecoration(
                        labelText: 'Email Body',
                        border: OutlineInputBorder(),
                        errorText: _composeBodyError,
                      ),
                      validator: _validateContent,
                      onChanged: (value) {
                        setState(() {
                          _composeBodyError = _validateContent(value);
                        });
                      },
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedLength,
                    decoration: InputDecoration(
                      labelText: 'Length',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        ['Long', 'Short'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLength = newValue ?? 'Long';
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _tone,
                    decoration: InputDecoration(
                      labelText: 'Choose a tone',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        ['Friendly', 'Professional', 'Casual'].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _tone = newValue ?? 'Friendly';
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _language,
                    decoration: InputDecoration(
                      labelText: 'Language',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        ['US English', 'Vietnamese', 'Spanish'].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _language = newValue ?? 'US English';
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              if (_formKey.currentState!.validate()) {
                                _generateEmailFromDrawer();
                              }
                            },
                    style: ElevatedButton.styleFrom(
                          backgroundColor: theme.secondary,
                          foregroundColor: theme.primaryText,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Response Email',
                          style: theme.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                  ),
                    ]
                  )
                ],
              ],
            ),
          ),
        ),
      ),
      body: Column(
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
                          theme.primaryBackground,
                          theme.primaryBackground,
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
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      border: Border.all(color: theme.alternate, width: 1.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_tabController.index == 1 &&
                            improvedActions
                                .isNotEmpty) // Show only if improvedActions exist
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children:
                                          improvedActions.map((action) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: ActionChip(
                                                label: Text(
                                                  action,
                                                  style: theme.bodyMedium,
                                                ),
                                                onPressed: () {
                                                  _composeActionController
                                                      .text = action;
                                                  _generateEmailFromDrawer();
                                                },
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: theme.secondaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      improvedActions.clear();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            16.0,
                            12.0,
                            16.0,
                            12.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  key: textFieldKey,
                                  controller: _model.textController,
                                  focusNode: _model.textFieldFocusNode,
                                  autofocus: false,
                                  textCapitalization:
                                      TextCapitalization.sentences,
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
                                        JarvisTheme.of(
                                          context,
                                        ).primaryBackground,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
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
                                  validator: null,
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
                      ],
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
                    currentAssistant.name,
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

class AIChatMessageModel extends FlutterFlowModel<EmailGeneratorPage> {
  TextEditingController? textController;
  FocusNode? textFieldFocusNode;
  @override
  void initState(BuildContext context) {
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
  }
}
