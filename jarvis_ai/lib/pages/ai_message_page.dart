import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jarvis_ai/components/card_prompt_widget.dart';
import 'package:jarvis_ai/models/conversation.dart';
import 'package:jarvis_ai/models/prompt.dart';
import 'package:jarvis_ai/models/thread_message.dart';
import 'package:jarvis_ai/models/token.dart';
import 'package:jarvis_ai/pages/prompt_create._page.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/flutter_flow_choice_chips.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/flutter_flow_theme.dart';
import 'package:jarvis_ai/theme/form_field_controller.dart';
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

class AIChatMessageModel extends FlutterFlowModel<AIMessagePage> {
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(String?)? textControllerValidator;
  ScrollController? promptScrollController;
  OverlayEntry? promptOverlayEntry;
  ScrollController? promptDrawerScrollController;
  bool isPromptDropdownVisible = false;

  FocusNode? promptSearchFieldFocusNode;
  TextEditingController? promptSearchController;
  FormFieldController<List<String>>? choiceChipsController;
  String? get choiceChipsValue => choiceChipsController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsController?.value = val != null ? [val] : [];
  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
    promptScrollController = ScrollController();
    promptDrawerScrollController = ScrollController();
    promptSearchController = TextEditingController();
    promptSearchFieldFocusNode = FocusNode();
    choiceChipsController = FormFieldController<List<String>>(['All']);
  }

  @override
  void initState(BuildContext context) {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    promptScrollController?.dispose();
    promptOverlayEntry?.remove();
    promptOverlayEntry = null;
    promptDrawerScrollController?.dispose();
    promptSearchFieldFocusNode?.dispose();
    promptSearchController?.dispose();
    choiceChipsController?.dispose();
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
  Token? currentToken;
  GlobalKey textFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _model = AIChatMessageModel();
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _model.textController!.addListener(_handleTextChange);
    loadUsage();
    _loadAssistants();
    _loadPrompts(refresh: true);
    _model.promptScrollController?.addListener(() {
      if (_model.promptScrollController!.position.pixels >=
          _model.promptScrollController!.position.maxScrollExtent - 50) {
        if (widget.apiStore.jarvisService.hasMorePrompts &&
            !widget.apiStore.jarvisService.isLoading) {
          widget.apiStore.jarvisService.loadMorePrompts();
        }
      }
    });
    _model.promptDrawerScrollController?.addListener(() {
      if (_model.promptDrawerScrollController!.position.pixels >=
          _model.promptDrawerScrollController!.position.maxScrollExtent - 50) {
        if (widget.apiStore.jarvisService.hasMorePrompts &&
            !widget.apiStore.jarvisService.isLoading) {
          widget.apiStore.jarvisService.loadMorePrompts();
        }
      }
    });
  }

  void _handleTextChange() {
    final text = _model.textController!.text;
    if (text.startsWith('/')) {
      if (!_model.isPromptDropdownVisible) {
        _showPromptDropdown();
      }
    } else {
      if (_model.isPromptDropdownVisible) {
        _hidePromptDropdown();
      }
    }
  }

  void _hidePromptDropdown() {
    _model.promptOverlayEntry?.remove();
    _model.promptOverlayEntry = null;
    setState(() {
      _model.isPromptDropdownVisible = false;
    });
  }

  void _showPromptDropdown() {
    if (_model.promptOverlayEntry != null) return;

    final RenderBox? renderBox =
        textFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _model.promptOverlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: position.dx,
            top: position.dy - 250,
            width: size.width,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Observer(
                  builder: (context) {
                    final jarvisService = widget.apiStore.jarvisService;
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _model.promptScrollController,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: jarvisService.prompts.length + 1,
                            itemBuilder: (context, index) {
                              if (index < jarvisService.prompts.length) {
                                final prompt = jarvisService.prompts[index];
                                return ListTile(
                                  title: Text(
                                    prompt.title ?? 'Untitled',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  onTap: () {
                                    _hidePromptDropdown();
                                    _showPromptDialog(prompt, context);
                                  },
                                );
                              } else if (jarvisService.isLoading) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_model.promptOverlayEntry!);
    setState(() {
      _model.isPromptDropdownVisible = true;
    });
  }

  Future<void> loadUsage() async {
    try {
      final response = await widget.apiStore.jarvisService.getUsage();
      setState(() {
        currentToken = response;
      });
    } catch (e) {
      print('Error loading usage: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load usage')));
      setState(() {
        currentToken = null;
      });
    }
  }

  void _showPromptDialog(Prompt prompt, BuildContext dialogContext) {
    final TextEditingController userInputController = TextEditingController();
    final theme = JarvisTheme.of(dialogContext);
    String selectedLanguage = 'Auto';
    showDialog(
      context: dialogContext,
      builder:
          (context) => Observer(
            builder: (context) {
              // Find the latest prompt from the service to ensure we have the updated favorite status
              final updatedPrompt = widget.apiStore.jarvisService.prompts
                  .firstWhere((p) => p.id == prompt.id, orElse: () => prompt);
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      updatedPrompt.title ?? 'Untitled Prompt',
                      style: theme.titleMedium,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            updatedPrompt.isFavorite ?? false
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                updatedPrompt.isFavorite ?? false
                                    ? Colors.red
                                    : Colors.white,
                            size: 24.0,
                          ),
                          onPressed: () {
                            _handleFavoriteToggle(updatedPrompt.id);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 24),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Prompt',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        updatedPrompt.content ?? '',
                        style: theme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Output Language',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: 'Auto',
                        items:
                            ['Auto', 'English', 'Spanish', 'French']
                                .map(
                                  (lang) => DropdownMenuItem(
                                    value: lang,
                                    child: Text(lang),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLanguage = value!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Text',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: userInputController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Enter your text here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _sendMessageWithPrompt(
                        promptContent: updatedPrompt.content ?? '',
                        userInput: userInputController.text,
                        language: selectedLanguage,
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Send'),
                  ),
                ],
              );
            },
          ),
    );
  }

  Future<void> _sendMessageWithPrompt({
    required String promptContent,
    required String userInput,
    required String language,
  }) async {
    String modifiedPrompt = promptContent;
    final RegExp placeholderPattern = RegExp(r'\[([^\]]*)\]');

    if (userInput.isNotEmpty) {
      if (placeholderPattern.hasMatch(promptContent)) {
        modifiedPrompt = promptContent.replaceAllMapped(
          placeholderPattern,
          (Match match) => userInput,
        );
        if (language != 'Auto') {
          modifiedPrompt = '$modifiedPrompt\n Response in language: $language';
        }
      } else {
        if (language != 'Auto') {
          modifiedPrompt =
              '$modifiedPrompt\n User Input: $userInput \n Response in language: $language';
        } else {
          modifiedPrompt = '$modifiedPrompt\n User Input: $userInput';
        }
      }
    }
    final message = modifiedPrompt;
    setState(() {
      isLoading = true;
      messages.add(
        Message(assistant: currentAssistant!, content: message, role: 'user'),
      );
      _model.textController?.clear();
    });
    try {
      final response = await widget.apiStore.jarvisService.sendMessage(
        content: message,
        assistant: currentAssistant!,
        conversationHistory: conversationHistory,
      );
      if (response == null || response?.message == null) return;
      setState(() {
        final modelResponse = Message(
          assistant: currentAssistant!,
          content: response.message ?? 'No response received',
          role: 'model',
        );
        messages.add(modelResponse);
        conversationHistory.addAll([
          messages[messages.length - 2].toJson(),
          modelResponse.toJson(),
        ]);
        if (currentToken != null && response.remainingUsage != null) {
          currentToken = currentToken!.copyWith(
            availableTokens: response.remainingUsage,
          );
        }
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

  Future<void> _handleFavoriteToggle(String promptId) async {
    try {
      await widget.apiStore.jarvisService.toggleFavorite(promptId);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to toggle favorite: $e')));
    }
  }

  Future<void> _loadPrompts({bool refresh = false}) async {
    try {
      await widget.apiStore.jarvisService.getPrompts(
        refresh: refresh,
        search: _model.promptSearchController?.text ?? '',
        isPublic:
            _model.choiceChipsValue == 'Public'
                ? true
                : _model.choiceChipsValue == 'Private'
                ? false
                : null,
        isFavorite: _model.choiceChipsValue == 'Favorites' ? true : null,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load prompts: ${e.toString()}')),
      );
    }
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
      if (response == null || response?.message == null) return;
      setState(() {
        final modelResponse = Message(
          assistant: currentAssistant!,
          content: response.message ?? 'No response received',
          role: 'model',
        );
        messages.add(modelResponse);
        conversationHistory.addAll([
          messages[messages.length - 2].toJson(),
          modelResponse.toJson(),
        ]);
        if (currentToken != null && response.remainingUsage != null) {
          currentToken = currentToken!.copyWith(
            availableTokens: response.remainingUsage,
          );
        }
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
    final theme = JarvisTheme.of(context);
    return Scaffold(
      backgroundColor: JarvisTheme.of(context).primaryBackground,
      drawer: Drawer(
        width: 400,
        backgroundColor: theme.primaryBackground,
        child: Column(
          children: [
            AppBar(
              backgroundColor: theme.secondaryBackground,
              automaticallyImplyLeading: false,
              title: Text('Prompt Library', style: theme.titleMedium),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context); // Close the drawer
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                controller: _model.promptSearchController,
                focusNode: _model.promptSearchFieldFocusNode,
                onChanged: (value) {
                  _loadPrompts(refresh: true);
                },
                decoration: InputDecoration(
                  hintText: 'Search prompts...',
                  hintStyle: theme.labelMedium,
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.alternate),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.alternate),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.primary),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FlutterFlowChoiceChips(
                options: const [
                  ChipData('All'),
                  ChipData('Public'),
                  ChipData('Private'),
                  ChipData('Favorites'),
                ],
                onChanged: (val) {
                  setState(() {
                    _model.choiceChipsValue = val?.firstOrNull;
                  });
                  _loadPrompts(refresh: true);
                },
                selectedChipStyle: ChipStyle(
                  backgroundColor: theme.secondary,
                  textStyle: theme.bodyMedium.override(
                    fontFamily: 'Inter',
                    color: theme.info,
                  ),
                  iconColor: theme.info,
                  iconSize: 16,
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(8),
                ),
                unselectedChipStyle: ChipStyle(
                  backgroundColor: theme.secondaryBackground,
                  textStyle: theme.bodyMedium.override(
                    fontFamily: 'Inter',
                    color: theme.secondaryText,
                  ),
                  iconColor: theme.secondaryText,
                  iconSize: 16,
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(8),
                ),
                chipSpacing: 18,
                rowSpacing: 8,
                multiselect: false,
                alignment: WrapAlignment.center,
                controller:
                    _model.choiceChipsController ??=
                        FormFieldController<List<String>>([]),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _loadPrompts(refresh: true),
                child: Observer(
                  builder: (context) {
                    final prompts =
                        widget.apiStore.jarvisService.prompts.toList();
                    if (widget.apiStore.jarvisService.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (prompts.isEmpty &&
                        !widget.apiStore.jarvisService.isLoading) {
                      return Center(
                        child: Text(
                          'No prompts available',
                          style: JarvisTheme.of(context).bodyMedium,
                        ),
                      );
                    }
                    return Builder(
                      builder: (dialogContext) {
                        return ListView.builder(
                          controller: _model.promptDrawerScrollController,
                          itemCount:
                              widget.apiStore.jarvisService.prompts.length +
                              (widget.apiStore.jarvisService.hasMorePrompts
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            if (index >=
                                widget.apiStore.jarvisService.prompts.length) {
                              return widget.apiStore.jarvisService.isLoading
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : const SizedBox.shrink();
                            }

                            Prompt prompt =
                                widget.apiStore.jarvisService.prompts[index];
                            return CardPromtWidget(
                              prompt: prompt,
                              onFavoriteChanged: (isFavorite) {
                                _handleFavoriteToggle(prompt.id);
                              },
                              jarvisService: widget.apiStore.jarvisService,
                              onEditPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PromptCreatingPage(
                                        apiStore: widget.apiStore,
                                        existingPrompt: prompt,
                                      );
                                    },
                                  ),
                                );
                                if (result == true) {
                                  await _loadPrompts(refresh: true);
                                }
                              },
                              onTap: () {
                                print('Prompt tapped: ${prompt.title}');
                                Navigator.pop(context);
                                _showPromptDialog(prompt, dialogContext);
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 1.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x00FFFFFF),
                      JarvisTheme.of(context).primaryBackground,
                    ],
                    stops: [0.0, 1.0],
                    begin: AlignmentDirectional(-1.0, 0.0),
                    end: AlignmentDirectional(1.0, 0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    16.0,
                    0.0,
                    16.0,
                    16.0,
                  ),
                  child: FFButtonWidget(
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/create-prompt',
                      );
                      if (result == true) {
                        await _loadPrompts(refresh: true);
                      }
                    },
                    text: 'Create New Prompt',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding: EdgeInsetsDirectional.fromSTEB(
                        16.0,
                        0.0,
                        16.0,
                        0.0,
                      ),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                      ),
                      color: JarvisTheme.of(context).secondary,
                      textStyle: JarvisTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter Tight',
                        color: JarvisTheme.of(context).info,
                        letterSpacing: 0.0,
                      ),
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
            Navigator.pop(context);
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
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.local_fire_department),
                                  Text(
                                    currentToken?.availableTokens.toString() ??
                                        '0',
                                    style: JarvisTheme.of(
                                      context,
                                    ).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color:
                                          JarvisTheme.of(context).primaryText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12.0),
                            Builder(
                              builder:
                                  (context) => JarvisIconButton(
                                    borderRadius: 24,
                                    buttonSize: 48,
                                    fillColor: theme.secondary,
                                    icon: const Icon(
                                      Icons.book_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                  ),
                            ),
                            SizedBox(width: 12.0),
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
                                      JarvisTheme.of(context).primaryBackground,
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
