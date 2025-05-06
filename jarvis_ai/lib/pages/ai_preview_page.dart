import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jarvis_ai/models/assistant.dart';
import 'package:jarvis_ai/models/knowledgebase.dart';
import 'package:jarvis_ai/models/prompt.dart';
import 'package:jarvis_ai/models/thread_message.dart';
import 'package:jarvis_ai/pages/ai_bot_create.dart';
import 'package:jarvis_ai/pages/prompt_create._page.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/flutter_flow_theme.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';
import 'package:jarvis_ai/components/card_prompt_widget.dart';
import 'package:jarvis_ai/theme/flutter_flow_choice_chips.dart';
import 'package:jarvis_ai/theme/form_field_controller.dart';
import 'package:mobx/mobx.dart';
class PreviewpageModel extends FlutterFlowModel<PreviewpageWidget> {
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(String?)? textControllerValidator;
  ScrollController? knowledgeBaseScrollController;
  ScrollController? chatScrollController;
  ScrollController? drawerScrollController;
  ScrollController? promptDrawerScrollController;
  ScrollController? knowledgeUnitsScrollController;

  FocusNode? instructionFieldFocusNode;
  TextEditingController? instructionController;
  String? Function(String?)? instructionControllerValidator;

  ScrollController? promptScrollController;
  OverlayEntry? promptOverlayEntry;
  bool isPromptDropdownVisible = false;

  FocusNode? promptSearchFieldFocusNode;
  TextEditingController? promptSearchController;
  FormFieldController<List<String>>? choiceChipsController;
  String? get choiceChipsValue => choiceChipsController?.value?.firstOrNull;
  FocusNode? knowledgeUnitsSearchFieldFocusNode;
  FocusNode? knowledgeBasesSearchFieldFocusNode;
  TextEditingController? knowledgeUnitsSearchController;
  TextEditingController? knowledgeBasesSearchController;
  set choiceChipsValue(String? val) =>
      choiceChipsController?.value = val != null ? [val] : [];
  @observable
  ObservableList<PlatformFile> selectedFiles = ObservableList<PlatformFile>();
  @observable
  String? fileError;
  @action
  void addFiles(List<PlatformFile> files) {
    selectedFiles.addAll(files);
  }

  @action
  void removeFile(PlatformFile file) {
    selectedFiles.remove(file);
  }

  @override
  void initState(BuildContext context) {
    textControllerValidator = (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a message';
      }
      return null;
    };
    knowledgeBaseScrollController = ScrollController();
    chatScrollController = ScrollController();
    drawerScrollController = ScrollController();
    promptScrollController = ScrollController();
    promptDrawerScrollController = ScrollController();
    promptSearchController = TextEditingController();

    knowledgeUnitsScrollController = ScrollController();
    promptSearchFieldFocusNode = FocusNode();
    choiceChipsController = FormFieldController<List<String>>(['All']);
    knowledgeUnitsSearchController = TextEditingController();
    knowledgeUnitsSearchFieldFocusNode = FocusNode();
    knowledgeBasesSearchFieldFocusNode = FocusNode();
    knowledgeBasesSearchController = TextEditingController();
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
    knowledgeBaseScrollController?.dispose();
    chatScrollController?.dispose();
    drawerScrollController?.dispose();
    instructionFieldFocusNode?.dispose();
    instructionController?.dispose();
    promptScrollController?.dispose();
    promptOverlayEntry?.remove();
    promptOverlayEntry = null;

    promptDrawerScrollController?.dispose();
    promptSearchFieldFocusNode?.dispose();
    promptSearchController?.dispose();
    choiceChipsController?.dispose();
    knowledgeUnitsScrollController?.dispose();
    knowledgeUnitsSearchFieldFocusNode?.dispose();
    knowledgeUnitsSearchController?.dispose();
  }
}

class PreviewpageWidget extends StatefulWidget {
  const PreviewpageWidget({
    super.key,
    required this.apiStore,
    this.existingAssistant,
  });

  final ApiStore apiStore;
  final String? existingAssistant;

  @override
  State<PreviewpageWidget> createState() => _PreviewpageWidgetState();
}

class _PreviewpageWidgetState extends State<PreviewpageWidget> {
  late PreviewpageModel _model;
  AssistantDetail? _assistant;
  GlobalKey textFieldKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedKnowledgeBaseId;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PreviewpageModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.instructionController ??= TextEditingController();
    _model.instructionFieldFocusNode ??= FocusNode();
    _model.textController!.addListener(_handleTextChange);

    _fetchAssistant();
    _fetchKnowledgeBases(refresh: true);
    _fetchGlobalKnowledgeBases(refresh: true);
    _loadPrompts(refresh: true);

    _model.knowledgeBaseScrollController?.addListener(() {
      if (_model.knowledgeBaseScrollController!.position.pixels >=
          _model.knowledgeBaseScrollController!.position.maxScrollExtent -
              200) {
        if (widget.apiStore.kbService.hasMoreKnowledgeBases &&
            !widget.apiStore.kbService.isLoading &&
            widget.existingAssistant != null) {
          widget.apiStore.kbService.loadMoreKnowledgeBases(
            assistantId: widget.existingAssistant!,
          );
        }
      }
    });

    _model.promptScrollController?.addListener(() {
      if (_model.promptScrollController!.position.pixels >=
          _model.promptScrollController!.position.maxScrollExtent - 50) {
        if (widget.apiStore.jarvisService.hasMorePrompts &&
            !widget.apiStore.jarvisService.isLoading) {
          widget.apiStore.jarvisService.loadMorePrompts();
        }
      }
    });

    _model.drawerScrollController?.addListener(() {
      if (_model.drawerScrollController!.position.pixels >=
          _model.drawerScrollController!.position.maxScrollExtent - 200) {
        if (widget.apiStore.kbService.hasMoreGlobalKnowledgeBases &&
            !widget.apiStore.kbService.isLoading) {
          widget.apiStore.kbService.loadMoreGlobalKnowledgeBases();
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
    _model.knowledgeUnitsScrollController?.addListener(() {
      if (_model.knowledgeUnitsScrollController!.position.pixels >=
          _model.knowledgeUnitsScrollController!.position.maxScrollExtent -
              50) {
        if (widget.apiStore.kbService.hasMoreUnits &&
            !widget.apiStore.kbService.isUnitLoading &&
            selectedKnowledgeBaseId != null) {
          widget.apiStore.kbService.loadMoreKnowledgeUnits(
            id: selectedKnowledgeBaseId as String,
          );
        }
      }
    });
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'docx',
          'pdf',
          '.c',
          '.cpp',
          '.html',
          '.java',
          '.json',
          '.md',
          '.php',
          '.pptx',
          '.py',
          '.rb',
          '.tex',
          '.txt',
        ],
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final files = result.files;
        files.forEach(
          (file) => print(
            'Picked file: name=${file.name}, path=${file.path}, bytes=${file.bytes?.length}, size=${file.size}',
          ),
        );
        setState(() {
          _model.addFiles(files);
        });
      } else {
        print('No file picked');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick file: $e')));
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

  Future<void> _fetchUnits({
    bool refresh = false,
    required String knowledgeId,
  }) async {
    setState(() {
      selectedKnowledgeBaseId = knowledgeId;
    });
    try {
      await widget.apiStore.kbService.getKnowledgeUnits(
        refresh: refresh,
        search: _model.knowledgeUnitsSearchController?.text ?? '',
        knowledgeId: knowledgeId,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Units: ${e.toString()}')),
      );
    }
  }

  Future<void> _removeKnowledgebase(String id) async {
    try {
      final result = await widget.apiStore.kbService.removeKnowledgeBaseFromBot(
        assistantId: widget.existingAssistant!,
        knowledgeId: id,
      );
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Knowledge base removed successfully')),
        );
        await _fetchKnowledgeBases(refresh: true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove knowledge base')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete knowledgebase: ${e.toString()}'),
        ),
      );
    }
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

  void _hidePromptDropdown() {
    _model.promptOverlayEntry?.remove();
    _model.promptOverlayEntry = null;
    setState(() {
      _model.isPromptDropdownVisible = false;
    });
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

  void _showCreateKnowledgeBaseDialog() {
    final TextEditingController knowledgeBaseNameController =
        TextEditingController();
    final TextEditingController knowledgeBaseDescriptionController =
        TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final theme = JarvisTheme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Create a Knowledge Base', style: theme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Knowledge Base Name',
                            style: theme.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(' *', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: knowledgeBaseNameController,
                        maxLength: 50,
                        decoration: InputDecoration(
                          hintText:
                              'Enter a unique name for your knowledge base',
                          hintStyle: theme.bodyMedium.copyWith(
                            color: theme.secondaryText,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.alternate),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.primary),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          if (value.length > 50) {
                            return 'Name cannot exceed 50 characters';
                          }
                          // Simulate checking for uniqueness
                          if (widget.apiStore.kbService.globalKnowledgeBases
                              .any((kb) => kb.knowledgeName == value.trim())) {
                            return 'Name must be unique';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${knowledgeBaseNameController.text.length}/50 characters',
                          style: theme.bodySmall.copyWith(
                            color: theme.secondaryText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Description',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: knowledgeBaseDescriptionController,
                        maxLength: 500,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText:
                              'Briefly describe the purpose of the knowledge base (e.g., Jarvis AI\'s knowledge base...)',
                          hintStyle: theme.bodyMedium.copyWith(
                            color: theme.secondaryText,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.alternate),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.primary),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value != null && value.length > 500) {
                            return 'Description cannot exceed 500 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${knowledgeBaseDescriptionController.text.length}/500 characters',
                          style: theme.bodySmall.copyWith(
                            color: theme.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: theme.primaryText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // Simulate creating a knowledge base
                      final newKnowledgeBase = await widget.apiStore.kbService
                          .createKnowledgeBase(
                            name: knowledgeBaseNameController.text.trim(),
                            description:
                                knowledgeBaseDescriptionController.text.trim(),
                          );
                      if (newKnowledgeBase != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Knowledge base created successfully',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Knowledge base created failed'),
                          ),
                        );
                      }
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: theme.info,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    // Add listeners for character count updates
    knowledgeBaseNameController.addListener(() {
      setState(() {});
    });
    knowledgeBaseDescriptionController.addListener(() {
      setState(() {});
    });
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

  void showAddLocalFile(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Import local files'),
          content: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: JarvisTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: JarvisTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Upload documents',
                                    style: JarvisTheme.of(
                                      context,
                                    ).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color:
                                          JarvisTheme.of(context).primaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                  JarvisIconButton(
                                    borderRadius: 20.0,
                                    buttonSize: 40.0,
                                    icon: Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: JarvisTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    onPressed: () {
                                      _pickFile();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Divider(
                                height: 1.0,
                                thickness: 1.0,
                                color: JarvisTheme.of(context).alternate,
                              ),
                              const SizedBox(height: 16.0),
                              if (_model.fileError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    _model.fileError!,
                                    style: JarvisTheme.of(
                                      context,
                                    ).bodySmall.copyWith(
                                      color: JarvisTheme.of(context).error,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8.0),
                              Observer(
                                builder:
                                    (_) =>
                                        _model.selectedFiles.isEmpty
                                            ? Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional.fromSTEB(
                                                        4.0,
                                                        0.0,
                                                        4.0,
                                                        0.0,
                                                      ),
                                                  child: Icon(
                                                    Icons.description_outlined,
                                                    color:
                                                        JarvisTheme.of(
                                                          context,
                                                        ).secondaryText,
                                                    size: 24.0,
                                                  ),
                                                ),
                                                Text(
                                                  'No documents uploaded yet',
                                                  style: JarvisTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                    fontFamily: 'Inter',
                                                    color:
                                                        JarvisTheme.of(
                                                          context,
                                                        ).secondaryText,
                                                    letterSpacing: 0.0,
                                                  ),
                                                ),
                                              ],
                                            )
                                            : Column(
                                              children:
                                                  _model.selectedFiles.map((
                                                    file,
                                                  ) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                          ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional.fromSTEB(
                                                                      4.0,
                                                                      0.0,
                                                                      4.0,
                                                                      0.0,
                                                                    ),
                                                                child: Icon(
                                                                  Icons
                                                                      .description_outlined,
                                                                  color:
                                                                      JarvisTheme.of(
                                                                        context,
                                                                      ).primaryText,
                                                                  size: 24.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                _truncateFilename(
                                                                  file.name,
                                                                  maxLength: 20,
                                                                ),
                                                                style: JarvisTheme.of(
                                                                  context,
                                                                ).bodyMedium.override(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color:
                                                                      JarvisTheme.of(
                                                                        context,
                                                                      ).primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis, // Add ellipsis for overflow
                                                                maxLines:
                                                                    1, // Limit to one line
                                                                softWrap:
                                                                    false, // Prevent wrapping
                                                              ),
                                                            ],
                                                          ),
                                                          JarvisIconButton(
                                                            borderRadius: 20.0,
                                                            buttonSize: 40.0,
                                                            icon: Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              color:
                                                                  JarvisTheme.of(
                                                                    context,
                                                                  ).error,
                                                              size: 24.0,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                _model
                                                                    .removeFile(
                                                                      file,
                                                                    );
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Observer(
              builder:
                  (_) => ElevatedButton(
                    onPressed:
                        _model.selectedFiles.isEmpty
                            ? null
                            : () async {
                              try {
                                await widget.apiStore.kbService
                                    .uploadFileToKnowledgeBase(
                                      files: _model.selectedFiles,
                                      knowledgeId: selectedKnowledgeBaseId!,
                                    );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Files imported successfully',
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to import files: $e'),
                                  ),
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Import'),
                  ),
            ),
          ],
        );
      },
    );
  }

  Future<void> removeUnit(String unitId, String knowledgeId) async {
    try {
      await widget.apiStore.kbService.deleteUnit(
        unitId: unitId,
        knowledgeId: knowledgeId,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knowledge unit removed successfully')),
      );
    } catch (e) {
      print('Error removing knowledge unit: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove knowledge unit: $e')),
      );
    }
  }

  Future<void> updateUnitStatus(String knowledgeId,String unitId, bool status) async {
    try {
      await widget.apiStore.kbService.updateStatusUnit(
        knowledgeId: knowledgeId,
        unitId: unitId,
        status: status,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knowledge unit status updated')),
      );
    } catch (e) {
      print('Error updating knowledge unit status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update knowledge unit status: $e')),
      );
    }
  }

  void showImportWebSourceDialog() {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlController = TextEditingController(
    text: 'https://example.com',
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final theme = JarvisTheme.of(context);

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Import Web Source', style: theme.titleMedium),
            IconButton(
              icon: const Icon(Icons.close, size: 24),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Name',
                      style: theme.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(' *', style: TextStyle(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter knowledge unit name',
                    hintStyle: theme.bodyMedium.copyWith(
                      color: theme.secondaryText,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.alternate),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.primary),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Web URL',
                      style: theme.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(' *', style: TextStyle(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: urlController,
                  decoration: InputDecoration(
                    hintText: 'https://example.com',
                    hintStyle: theme.bodyMedium.copyWith(
                      color: theme.secondaryText,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.alternate),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: theme.primary),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'URL is required';
                    }
                    final urlPattern = RegExp(
                      r'^(https?:\/\/)?([\w\d\-_]+(\.[\w\d\-_]+)+)([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$',
                    );
                    if (!urlPattern.hasMatch(value)) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Limitation:',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• You can load up to 64 pages at a time',
                        style: theme.bodySmall,
                      ),
                      Text(
                        '• Need more? Contact us at myjarvischat@gmail.com',
                        style: theme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: theme.primaryText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            child: const Text('Back'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  final response = await widget.apiStore.kbService
                      .uploadWebToKnowledgeBase(
                        knowledgeId: selectedKnowledgeBaseId!,
                        unitName: nameController.text,
                        webUrl: urlController.text,
                      );
                  if (response != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Web source imported successfully'),
                      ),
                    );
                    await _fetchUnits(
                      refresh: true,
                      knowledgeId: selectedKnowledgeBaseId!,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to import web source'),
                      ),
                    );
                  }
                  Navigator.of(dialogContext).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to import web source: $e'),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[50],
              foregroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            child: const Text('Import'),
          ),
        ],
      );
    },
  );
}
  void showAddKnowledgeUnitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Knowledge Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.file_upload),
                  title: const Text('Local files'),
                  subtitle: const Text('Upload pdf, docx, ...'),
                  onTap: () {
                    Navigator.pop(context);
                    showAddLocalFile(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Website'),
                  subtitle: const Text('Connect Website to get data'),
                  onTap: () {
                    Navigator.pop(context);
                    showImportWebSourceDialog();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cloud),
                  title: const Text('Google Drive'),
                  subtitle: const Text('Coming soon'),
                  enabled: false,
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('GitHub Repository'),
                  subtitle: const Text('Connect to GitHub repositories'),
                  enabled: false,
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('GitLab Repository'),
                  subtitle: const Text('Connect to GitLab repositories'),
                  enabled: false,
                ),
                ListTile(
                  leading: const Icon(Icons.chat),
                  title: const Text('Slack'),
                  subtitle: const Text('Connect to Slack workspace'),
                  enabled: false,
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Confluence'),
                  subtitle: const Text('Connect to Confluence'),
                  enabled: false,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendMessageWithPrompt({
    required String promptContent,
    required String userInput,
    required String language,
  }) async {
    if (widget.existingAssistant == null ||
        _assistant == null ||
        _assistant!.openAiThreadIdPlay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assistant or thread ID is missing')),
      );
      return;
    }

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
    final userMessage = ThreadMessage(
      role: 'user',
      createdAt: (DateTime.now().millisecondsSinceEpoch ~/ 1000),
      content: message,
    );
    widget.apiStore.kbService.messages.add(userMessage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_model.chatScrollController != null &&
          _model.chatScrollController!.hasClients) {
        _model.chatScrollController!.jumpTo(
          _model.chatScrollController!.position.maxScrollExtent,
        );
      }
    });

    try {
      await widget.apiStore.kbService.sendMessage(
        assistantId: widget.existingAssistant!,
        threadId: _assistant!.openAiThreadIdPlay!,
        message: message,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_model.chatScrollController != null &&
            _model.chatScrollController!.hasClients) {
          _model.chatScrollController!.jumpTo(
            _model.chatScrollController!.position.maxScrollExtent,
          );
        }
      });
    } catch (e) {
      print('Error sending message with prompt: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send message: $e')));
    }
  }

  Future<void> _fetchAssistant() async {
    if (widget.existingAssistant == null) {
      print('Error: existingAssistant is null');
      return;
    }
    try {
      final assistant = await widget.apiStore.kbService.getAssistantById(
        id: widget.existingAssistant!,
      );
      print('Assistant fetched: ${assistant!.toJson()}');
      setState(() {
        _assistant = assistant;
        _model.instructionController!.text = assistant.instructions ?? '';
      });
      _fetchMessages(refresh: true);
    } catch (e) {
      print('Error fetching assistant: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load assistant: $e')));
    }
  }

  Future<void> _handleUpdateAssistant() async {
    try {
      if (_assistant == null) return;
      final instructions = _model.instructionController?.text ?? '';
      final assistant = await widget.apiStore.kbService
          .updateInstructionAssistant(
            assistantId: widget.existingAssistant!,
            instructions: instructions,
            assistantName: _assistant?.assistantName as String,
          );

      if (assistant != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${assistant.assistantName} updated successfully!'),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error in _handleAssistant: $e');
      debugPrint(stackTrace.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update AI Bot: ${e.toString()}')),
      );
    }
  }

  Future<void> _fetchKnowledgeBases({bool refresh = false}) async {
    if (widget.existingAssistant == null) {
      print('Error: existingAssistant is null');
      return;
    }
    try {
      await widget.apiStore.kbService.getKnowledgeBases(
        assistantId: widget.existingAssistant!,
        refresh: refresh,
      );
    } catch (e) {
      print('Error fetching knowledge bases: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load knowledge bases: $e')),
      );
    }
  }

  Future<void> _fetchGlobalKnowledgeBases({bool refresh = false}) async {
    try {
      await widget.apiStore.kbService.getGlobalKnowledgeBases(
        refresh: refresh,
        search: _model.knowledgeBasesSearchController?.text ?? '',
      );
    } catch (e) {
      print('Error fetching global knowledge bases: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load global knowledge bases: $e')),
      );
    }
  }

  Future<void> _fetchMessages({bool refresh = false}) async {
    if (_assistant == null || _assistant!.openAiThreadIdPlay == null) {
      print('Error: threadId is null');
      return;
    }
    try {
      await widget.apiStore.kbService.getThreadMessages(
        threadId: _assistant!.openAiThreadIdPlay!,
        refresh: refresh,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_model.chatScrollController != null &&
            _model.chatScrollController!.hasClients) {
          _model.chatScrollController!.jumpTo(
            _model.chatScrollController!.position.maxScrollExtent,
          );
        }
      });
    } catch (e) {
      print('Error fetching messages: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load messages: $e')));
    }
  }

  Future<void> _sendMessage() async {
    if (_model.textController!.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a message')));
      return;
    }
    if (widget.existingAssistant == null ||
        _assistant == null ||
        _assistant!.openAiThreadIdPlay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assistant or thread ID is missing')),
      );
      return;
    }
    final message = _model.textController!.text;
    _model.textController!.clear();
    final userMessage = ThreadMessage(
      role: 'user',
      createdAt: (DateTime.now().millisecondsSinceEpoch ~/ 1000),
      content: message,
    );
    widget.apiStore.kbService.messages.add(userMessage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_model.chatScrollController != null &&
          _model.chatScrollController!.hasClients) {
        _model.chatScrollController!.jumpTo(
          _model.chatScrollController!.position.maxScrollExtent,
        );
      }
    });
    try {
      await widget.apiStore.kbService.sendMessage(
        assistantId: widget.existingAssistant!,
        threadId: _assistant!.openAiThreadIdPlay!,
        message: message,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_model.chatScrollController != null &&
            _model.chatScrollController!.hasClients) {
          _model.chatScrollController!.jumpTo(
            _model.chatScrollController!.position.maxScrollExtent,
          );
        }
      });
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send message: $e')));
    }
  }

  Future<void> _attachKnowledgeBase(String knowledgeId) async {
    if (widget.existingAssistant == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Assistant ID is missing')));
      return;
    }
    try {
      final success = await widget.apiStore.kbService.attachKnowledgeBase(
        assistantId: widget.existingAssistant!,
        knowledgeId: knowledgeId,
      );
      if (success) {
        await widget.apiStore.kbService.getKnowledgeBases(
          assistantId: widget.existingAssistant!,
          refresh: true,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Knowledge base attached successfully')),
        );
        Navigator.pop(context); // Close the Drawer
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to attach knowledge base')),
        );
      }
    } catch (e) {
      print('Error attaching knowledge base: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error attaching knowledge base: $e')),
      );
    }
  }

  @override
  void dispose() {
    _model.textController!.removeListener(_handleTextChange);
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = JarvisTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: theme.primaryBackground,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                                  widget
                                      .apiStore
                                      .jarvisService
                                      .prompts
                                      .length) {
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
        endDrawer:
            selectedKnowledgeBaseId != null
                ? Drawer(
                  width: 400,
                  backgroundColor: theme.secondaryBackground,
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: theme.secondaryBackground,
                        automaticallyImplyLeading: false,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              selectedKnowledgeBaseId = null;
                              widget.apiStore.kbService.units.clear();
                            });
                            _scaffoldKey.currentState?.openEndDrawer();
                          },
                        ),
                        title: Text(
                          widget.apiStore.kbService.knowledgeBases
                                  .firstWhere(
                                    (kb) => kb.id == selectedKnowledgeBaseId,
                                    orElse:
                                        () => KnowledgeBase(
                                          knowledgeName: 'Knowledge Base',
                                        ),
                                  )
                                  .knowledgeName ??
                              'Knowledge Base',
                          style: theme.titleMedium,
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                selectedKnowledgeBaseId = null;
                                widget.apiStore.kbService.units.clear();
                                widget.apiStore.kbService.unitsPage = 0;
                                widget.apiStore.kbService.hasMoreUnits = true;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: TextFormField(
                          controller: _model.knowledgeUnitsSearchController,
                          focusNode: _model.knowledgeUnitsSearchFieldFocusNode,
                          onChanged: (value) {
                            _fetchUnits(
                              knowledgeId: selectedKnowledgeBaseId!,
                              refresh: true,
                            );
                          },
                          decoration: InputDecoration(
                            hintText: 'Search units...',
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
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            if (selectedKnowledgeBaseId != null) {
                              await _fetchUnits(
                                refresh: true,
                                knowledgeId: selectedKnowledgeBaseId!,
                              );
                            }
                          },
                          child: Observer(
                            builder: (context) {
                              final isLoading =
                                  widget.apiStore.kbService.isUnitLoading;
                              final units = widget.apiStore.kbService.units;
                              if (isLoading && units.isEmpty) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (units.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No knowledge units found',
                                    style: theme.bodyMedium,
                                  ),
                                );
                              }
                              return ListView.builder(
                                controller:
                                    _model.knowledgeUnitsScrollController,
                                itemCount:
                                    widget.apiStore.kbService.units.length,
                                itemBuilder: (context, index) {
                                  final unit =
                                      widget.apiStore.kbService.units[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: theme.alternate,
                                          width: 1,
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: Icon(
                                          unit.type == 'web' ? Icons.web : Icons.description,
                                          color: theme.secondaryText,
                                        ),
                                        title: Text(
                                          unit.name ?? 'Untitled',
                                          style: theme.bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Text(
                                              '${unit.size!.toStringAsFixed(2)} KB',
                                              style: theme.bodySmall.copyWith(
                                                color: Colors.green,
                                              ),
                                            ),
                                            // const SizedBox(width: 8),
                                            // Text(
                                            //   unit.type ?? 'Unknown',
                                            //   style: theme.bodySmall
                                            //       .copyWith(
                                            //         color:
                                            //             theme.secondaryText,
                                            //       ),
                                            // ),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Switch(
                                              value: unit.status!,
                                              onChanged: (value) {
                                                setState(() {
                                                  unit.status = value;
                                                });
                                                updateUnitStatus(
                                                  selectedKnowledgeBaseId!,
                                                  unit.id!,
                                                  value,
                                                );
                                              },
                                              activeColor: theme.primary,
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: theme.error,
                                              ),
                                              onPressed: () {
                                                removeUnit(
                                                  unit.id!,
                                                  selectedKnowledgeBaseId!,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showAddKnowledgeUnitDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primary,
                            foregroundColor: theme.info,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Add Knowledge Unit'),
                        ),
                      ),
                    ],
                  ),
                )
                : Drawer(
                  width: 300,
                  backgroundColor: theme.secondaryBackground,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: TextFormField(
                          controller: _model.knowledgeBasesSearchController,
                          focusNode: _model.knowledgeBasesSearchFieldFocusNode,
                          onChanged: (value) {
                            _fetchGlobalKnowledgeBases(refresh: true);
                          },
                          decoration: InputDecoration(
                            hintText: 'Search knowledge bases...',
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

                      Expanded(
                        child: RefreshIndicator(
                          child: Observer(
                            builder: (context) {
                              final kbService = widget.apiStore.kbService;
                              if (kbService.isLoading &&
                                  kbService.globalKnowledgeBases.isEmpty) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (kbService.globalKnowledgeBases.isEmpty) {
                                return const Center(
                                  child: Text('No knowledge bases found'),
                                );
                              }
                              return SingleChildScrollView(
                                controller: _model.drawerScrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        'Available Knowledge Bases',
                                        style: theme.titleMedium,
                                      ),
                                    ),
                                    ...kbService.globalKnowledgeBases.map(
                                      (kb) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: theme.primaryBackground,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: theme.alternate,
                                              width: 1,
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              kb.knowledgeName ?? 'Untitled',
                                              style: theme.bodyLarge,
                                            ),
                                            subtitle: Text(
                                              'Last updated: ${DateFormat('MMM d, yyyy').format(DateTime.parse(kb.updatedAt ?? DateTime.now().toIso8601String()))}',
                                              style: theme.bodySmall.copyWith(
                                                color: theme.secondaryText,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.add,
                                                color: theme.primary,
                                              ),
                                              onPressed:
                                                  () => _attachKnowledgeBase(
                                                    kb.id as String,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (kbService.isLoading)
                                      const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                          onRefresh:
                              () => _fetchGlobalKnowledgeBases(refresh: true),
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
                              16.0,
                              16.0,
                              16.0,
                            ),
                            child: FFButtonWidget(
                              onPressed: () async {
                                Navigator.pop(context);
                                _showCreateKnowledgeBaseDialog();
                              },
                              text: 'Create Knowledge Base',
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
                                textStyle: JarvisTheme.of(
                                  context,
                                ).titleSmall.override(
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            AppBar(
              backgroundColor: theme.secondaryBackground,
              automaticallyImplyLeading: false,
              leading: JarvisIconButton(
                borderColor: Colors.transparent,
                borderRadius: 20,
                buttonSize: 40,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: theme.primaryText,
                  size: 24,
                ),
                onPressed: () {
                  debugPrint('Back button pressed');
                  Navigator.pop(context);
                },
              ),
              title: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _assistant?.assistantName ?? 'AI Assistant',
                    style: theme.titleLarge,
                  ),
                  JarvisIconButton(
                    borderRadius: 20,
                    buttonSize: 40,
                    icon: Icon(Icons.edit, color: theme.primaryText, size: 24),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AIBotCreatePageWidget(
                              apiStore: widget.apiStore,
                              existingAssistantId: _assistant!.id,
                            );
                          },
                        ),
                      );
                      if (result == true) {
                        await _fetchAssistant();
                      }
                    },
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: JarvisIconButton(
                    borderRadius: 20,
                    buttonSize: 40,
                    icon: Icon(
                      Icons.settings,
                      color: theme.primaryText,
                      size: 24,
                    ),
                    onPressed: () {
                      debugPrint('Settings button pressed');
                    },
                  ),
                ),
              ],
              centerTitle: true,
              elevation: 0,
            ),
            Container(
              width: double.infinity,
              height: 0.5,
              decoration: BoxDecoration(color: theme.alternate),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Knowledge Base', style: theme.titleMedium),
                  Builder(
                    builder:
                        (context) => JarvisIconButton(
                          borderRadius: 20,
                          buttonSize: 40,
                          fillColor: theme.primary,
                          icon: Icon(Icons.add, color: theme.info, size: 24),
                          onPressed: () {
                            debugPrint('Add knowledge base button pressed');
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                  ),
                ],
              ),
            ),
            Observer(
              builder: (context) {
                final kbService = widget.apiStore.kbService;
                if (kbService.isLoading && kbService.knowledgeBases.isEmpty) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (kbService.knowledgeBases.isEmpty) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: Text('No knowledge bases found')),
                  );
                }
                return SizedBox(
                  height: 150,
                  child: SingleChildScrollView(
                    controller: _model.knowledgeBaseScrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...kbService.knowledgeBases.map(
                          (kb) => Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              16,
                              12,
                              16,
                              12,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                await _fetchUnits(
                                  refresh: true,
                                  knowledgeId: kb.id!,
                                );
                                _scaffoldKey.currentState?.openEndDrawer();
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: theme.secondaryBackground,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: theme.alternate,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              kb.knowledgeName ?? 'Untitled',
                                              style: theme.bodyLarge,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional.fromSTEB(
                                                    0,
                                                    4,
                                                    0,
                                                    0,
                                                  ),
                                              child: Text(
                                                'Last updated: ${DateFormat('MMM d, yyyy').format(DateTime.parse(kb.updatedAt ?? DateTime.now().toIso8601String()))}',
                                                style: theme.bodySmall.copyWith(
                                                  color: theme.secondaryText,
                                                  letterSpacing: 0.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      JarvisIconButton(
                                        borderRadius: 20,
                                        buttonSize: 40,
                                        icon: Icon(
                                          Icons.delete,
                                          color: theme.error,
                                          size: 24,
                                        ),
                                        onPressed: () async {
                                          if (await confirm(
                                            context,
                                            title: Text('Remove Confirm'),
                                            content: Text(
                                              'Do you want to remove ${kb.knowledgeName}',
                                            ),
                                            textOK: Text('Yes'),
                                            textCancel: Text('No'),
                                          )) {
                                            _removeKnowledgebase(kb.id!);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (kbService.isLoading)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Divider(
              height: 24,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: theme.alternate,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bot Instructions',
                    style: theme.titleMedium.override(
                      fontFamily: theme.titleMediumFamily,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  JarvisIconButton(
                    borderRadius: 20,
                    buttonSize: 40,
                    fillColor: theme.primary,
                    icon: Icon(Icons.edit, color: theme.info, size: 24),
                    onPressed: () {
                      print('fefwf');
                      _handleUpdateAssistant();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: Container(
                width: double.infinity,
                child: TextFormField(
                  controller: _model.instructionController,
                  focusNode: _model.instructionFieldFocusNode,
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'Write instruction for your Bot',
                    errorStyle: JarvisTheme.of(
                      context,
                    ).bodySmall.copyWith(color: JarvisTheme.of(context).error),
                    hintStyle: JarvisTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: JarvisTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: JarvisTheme.of(context).alternate,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: JarvisTheme.of(context).primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: JarvisTheme.of(context).secondaryBackground,
                  ),
                  style: JarvisTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                  ),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  cursorColor: JarvisTheme.of(context).primary,
                  validator: _model.instructionControllerValidator,
                ),
              ),
            ),
            Divider(
              height: 24,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: theme.alternate,
            ),
            Expanded(
              child: Observer(
                builder: (context) {
                  final kbService = widget.apiStore.kbService;
                  if (kbService.isLoading && kbService.messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (kbService.messages.isEmpty) {
                    return const Center(child: Text('No messages found'));
                  }
                  return SingleChildScrollView(
                    controller: _model.chatScrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children:
                          kbService.messages.map((message) {
                            final isAssistant = message.role == 'assistant';
                            final timestamp =
                                DateTime.fromMillisecondsSinceEpoch(
                                  message.createdAt * 1000,
                                );
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      isAssistant
                                          ? theme.secondaryBackground
                                          : theme.accent1,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isAssistant
                                            ? theme.alternate
                                            : theme.primary,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        isAssistant
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (isAssistant) ...[
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: theme.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                  0,
                                                  0,
                                                ),
                                            child: Icon(
                                              Icons.smart_toy_rounded,
                                              color: theme.info,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                      ],
                                      Flexible(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              isAssistant
                                                  ? CrossAxisAlignment.start
                                                  : CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              message.content,
                                              style: theme.bodyMedium.override(
                                                fontFamily:
                                                    theme.bodyMediumFamily,
                                                color: theme.primaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    theme.bodyMedium.fontWeight,
                                                fontStyle:
                                                    theme.bodyMedium.fontStyle,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional.fromSTEB(
                                                    0,
                                                    4,
                                                    0,
                                                    0,
                                                  ),
                                              child: Text(
                                                DateFormat(
                                                  'hh:mm a',
                                                ).format(timestamp),
                                                style: theme.bodySmall.override(
                                                  fontFamily:
                                                      theme.bodySmallFamily,
                                                  color: theme.secondaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      theme
                                                          .bodySmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      theme.bodySmall.fontStyle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!isAssistant) ...[
                                        const SizedBox(width: 12),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: theme.secondaryBackground,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: theme.primary,
                                              width: 1,
                                            ),
                                          ),
                                          child: Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                  0,
                                                  0,
                                                ),
                                            child: Icon(
                                              Icons.person,
                                              color: theme.primaryText,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: 0.5,
              decoration: BoxDecoration(color: theme.alternate),
            ),
            SafeArea(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  border: Border.all(color: theme.alternate, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            key: textFieldKey,
                            controller: _model.textController,
                            focusNode: _model.textFieldFocusNode,
                            autofocus: false,
                            textCapitalization: TextCapitalization.sentences,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              hintStyle: theme.labelMedium.override(
                                fontFamily: theme.labelMediumFamily,
                                color: theme.secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: theme.labelMedium.fontWeight,
                                fontStyle: theme.labelMedium.fontStyle,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: theme.alternate,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              filled: true,
                              fillColor: theme.primaryBackground,
                              contentPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                    16,
                                    12,
                                    16,
                                    12,
                                  ),
                            ),
                            style: theme.bodyMedium.override(
                              fontFamily: theme.bodyMediumFamily,
                              color: theme.primaryText,
                              letterSpacing: 0.0,
                              fontWeight: theme.bodyMedium.fontWeight,
                              fontStyle: theme.bodyMedium.fontStyle,
                            ),
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            cursorColor: theme.primary,
                            validator: _model.textControllerValidator,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Observer(
                          builder: (context) {
                            final kbService = widget.apiStore.kbService;
                            return JarvisIconButton(
                              borderRadius: 24,
                              buttonSize: 48,
                              fillColor:
                                  kbService.isMessageLoading
                                      ? Colors.grey
                                      : theme.secondary,
                              icon: Icon(
                                kbService.isMessageLoading
                                    ? Icons.hourglass_empty
                                    : Icons.send_rounded,
                                color: theme.info,
                                size: 24,
                              ),
                              onPressed:
                                  kbService.isMessageLoading
                                      ? null
                                      : _sendMessage,
                            );
                          },
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
    );
  }
}

String _truncateFilename(String filename, {int maxLength = 20}) {
  if (filename.length <= maxLength) return filename;

  final extension = filename.split('.').last;
  final nameWithoutExt = filename.substring(
    0,
    filename.length - extension.length - 1,
  );
  final prefixLength = (maxLength - extension.length - 3) ~/ 2; // 3 for "..."
  final suffixLength = maxLength - extension.length - 3 - prefixLength;

  return '${nameWithoutExt.substring(0, prefixLength)}...${nameWithoutExt.substring(nameWithoutExt.length - suffixLength)}.$extension';
}
