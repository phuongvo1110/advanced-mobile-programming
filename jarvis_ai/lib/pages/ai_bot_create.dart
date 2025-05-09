import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jarvis_ai/models/assistant.dart';
import 'package:jarvis_ai/models/datasource.dart'; // Added for Datasource model
import 'package:jarvis_ai/pages/ai_preview_page.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/flutter_flow_theme.dart';
import 'package:jarvis_ai/theme/form_field_controller.dart';
import 'package:jarvis_ai/theme/jarvis_drop_down.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';
import 'package:mobx/mobx.dart';

class AIBotCreatePageModel extends FlutterFlowModel<AIBotCreatePageWidget> {
  FocusNode? NameFieldFocusNode;
  TextEditingController? nameController;
  String? Function(String?)? nameControllerValidator;
  FocusNode? descriptionFieldFocusNode;
  TextEditingController? descriptionController;
  String? Function(String?)? descriptionControllerValidator;
  FocusNode? instructionFieldFocusNode;
  TextEditingController? instructionController;
  String? Function(String?)? instructionControllerValidator;
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void dispose() {
    NameFieldFocusNode?.dispose();
    nameController?.dispose();
    descriptionFieldFocusNode?.dispose();
    descriptionController?.dispose();
    instructionFieldFocusNode?.dispose();
    instructionController?.dispose();
  }

  @observable
  String? nameError;
  @observable
  String? descriptionError;
  @observable
  String? instructionError;
  @observable
  ObservableList<PlatformFile> selectedFiles = ObservableList<PlatformFile>();
  @observable
  String? fileError;
  @observable
  DatasourceRequest? slackDataSource;
  @observable
  DatasourceRequest? confluenceDataSource;
  @action
  void addFiles(List<PlatformFile> files) {
    selectedFiles.addAll(files);
  }

  @action
  void removeFile(PlatformFile file) {
    selectedFiles.remove(file);
  }

  void validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      nameError = 'Title is required';
    } else if (value.length > 100) {
      nameError = 'Name must be less than 100 characters';
    } else {
      nameError = null;
    }
  }

  void validateDescription(String? value) {
    if (value != null && value.length > 200) {
      descriptionError = 'Description must be less than 200 characters';
    } else {
      descriptionError = null;
    }
  }

  void validateInstruction(String? value) {
    if (value == null || value.trim().isEmpty) {
      instructionError = 'Instruction is required';
    } else if (value != null && value.length > 200) {
      instructionError = 'Instruction must be less than 200 characters';
    } else {
      instructionError = null;
    }
  }

  bool validateAll() {
    validateName(nameController?.text);
    validateDescription(descriptionController?.text);
    validateInstruction(instructionController?.text);
    return nameError == null &&
        descriptionError == null &&
        instructionError == null;
  }

  @action
  void setSlackDataSource(DatasourceRequest? dataSource) {
    slackDataSource = dataSource;
  }

  @action
  void setConfluenceDataSource(DatasourceRequest? dataSource) {
    confluenceDataSource = dataSource;
  }

  @override
  void initState(BuildContext context) {}
}

class AIBotCreatePageWidget extends StatefulWidget {
  const AIBotCreatePageWidget({
    super.key,
    required this.apiStore,
    this.existingAssistantId,
  });
  final ApiStore apiStore;
  final String? existingAssistantId;

  @override
  State<AIBotCreatePageWidget> createState() => _AIBotCreaePageWidgetState();
}

class _AIBotCreaePageWidgetState extends State<AIBotCreatePageWidget> {
  late AIBotCreatePageModel _model;
  bool _isCreating = false;
  AssistantDetail? existingAssistant;

  @override
  void initState() {
    super.initState();
    _model = AIBotCreatePageModel();
    _model.nameController ??= TextEditingController();
    _model.NameFieldFocusNode ??= FocusNode();
    _model.descriptionController ??= TextEditingController();
    _model.descriptionFieldFocusNode ??= FocusNode();
    _model.instructionController ??= TextEditingController();
    _model.instructionFieldFocusNode ??= FocusNode();

    if (widget.existingAssistantId != null) {
      _loadExistingAssistant();
    }
  }

  Future<void> _loadExistingAssistant() async {
    existingAssistant = await getAssistant();
    print('existing: $existingAssistant');
    if (existingAssistant != null && mounted) {
      setState(() {
        _model.nameController!.text = existingAssistant!.assistantName;
        _model.descriptionController!.text =
            existingAssistant!.description ?? '';
        _model.instructionController!.text =
            existingAssistant!.instructions ?? '';
      });
    }
  }

  Future<AssistantDetail?> getAssistant() async {
    return await widget.apiStore.kbService.getAssistantById(
      id: widget.existingAssistantId as String,
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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

  Future<void> _handleAssistant() async {
    if (!_model.validateAll()) {
      setState(() {});
      return;
    }
    if (_isCreating) return;

    setState(() {
      _isCreating = true;
    });

    try {
      final name = _model.nameController?.text ?? '';
      final instructions = _model.instructionController?.text ?? '';
      final description = _model.descriptionController?.text ?? '';

      final assistant =
          widget.existingAssistantId == null
              ? _model.selectedFiles.isEmpty
                  ? await widget.apiStore.kbService.createAssistant(
                    assistantName: name,
                    instructions: instructions,
                    description: description,
                  )
                  : await widget.apiStore.kbService.uploadFileCreateBot(
                    assistantName: name,
                    description: description,
                    instructions: instructions,
                    files: _model.selectedFiles,
                  )
              : await widget.apiStore.kbService.updateAssistant(
                assistantId: widget.existingAssistantId!,
                assistantName: name,
                instructions: instructions,
                description: description,
              );

      // Handle Slack and Confluence uploads only for new assistant creation
      if (widget.existingAssistantId == null && assistant != null) {
        // Fetch knowledge bases and wait for the result
        await widget.apiStore.kbService.getKnowledgeBases(
          assistantId: assistant.id,
          refresh: true
        );

        // Check if knowledgeBases is populated
        if (widget.apiStore.kbService.knowledgeBases.isEmpty) {
          throw Exception('No knowledge bases found for the assistant');
        }

        // Handle Slack data source
        if (_model.slackDataSource != null) {
          final slackUnits = await widget.apiStore.kbService
              .uploadSlackToKnowledgeBase(
                knowledgeId:
                    widget.apiStore.kbService.knowledgeBases.first.id as String,
                request: _model.slackDataSource!,
              );
          if (slackUnits == null || slackUnits.isEmpty) {
            throw Exception('Failed to upload Slack data to knowledge base');
          }
        }

        // Handle Confluence data source
        if (_model.confluenceDataSource != null) {
          final confluenceUnit = await widget.apiStore.kbService
              .uploadConfluenceToKnowledgeBase(
                knowledgeId:
                    widget.apiStore.kbService.knowledgeBases.first.id as String,
                request: _model.confluenceDataSource!,
              );
          if (confluenceUnit == null) {
            throw Exception(
              'Failed to upload Confluence data to knowledge base',
            );
          }
        }
      }

      if (assistant != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.existingAssistantId == null
                  ? 'AI Bot created successfully!'
                  : '${assistant.assistantName} updated successfully!',
            ),
          ),
        );
      }

      // Navigate or pop based on whether this is a new assistant or an update
      if (widget.existingAssistantId == null) {
        widget.apiStore.kbService.knowledgeBases.clear();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PreviewpageWidget(
                apiStore: widget.apiStore,
                existingAssistant: assistant!.id,
              );
            },
          ),
        );
      } else {
        widget.apiStore.kbService.knowledgeBases.clear();
        Navigator.pop(context, true);
      }
    } catch (e, stackTrace) {
      debugPrint('Error in _handleAssistant: $e');
      debugPrint(stackTrace.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existingAssistantId == null
                ? 'Failed to create AI Bot: ${e.toString()}'
                : 'Failed to update AI Bot: ${e.toString()}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
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
                  leading: const Image(
                    image: AssetImage('assets/Slack_icon.png'),
                    width: 20.0,
                    height: 20.0,
                  ),
                  title: const Text('Slack'),
                  subtitle: const Text('Connect to Slack workspace'),
                  onTap: () async {
                    Navigator.pop(context);
                    await showImportSlackDialog();
                    setState(() {}); // Trigger rebuild after dialog closes
                  },
                ),
                ListTile(
                  leading: const Image(
                    image: AssetImage('assets/confluence.png'),
                    width: 20.0,
                    height: 20.0,
                  ),
                  title: const Text('Confluence'),
                  subtitle: const Text('Connect to Confluence'),
                  onTap: () async {
                    Navigator.pop(context);
                    await showImportConfluenceDialog();
                    setState(() {}); // Trigger rebuild after dialog closes
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
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                softWrap: false,
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
                            : () {
                              Navigator.pop(context);
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Web source import requires a knowledge base. Please create the bot first.',
                      ),
                    ),
                  );
                  Navigator.of(dialogContext).pop();
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

  Future<void> showImportSlackDialog() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController tokenController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final theme = JarvisTheme.of(context);

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Import Slack Workspace', style: theme.titleMedium),
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
                        'Workspace Name',
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
                      hintText: 'Enter Slack workspace name',
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
                        return 'Workspace name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Slack Token',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: tokenController,
                    decoration: InputDecoration(
                      hintText: 'xoxb-...',
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
                        return 'Slack token is required';
                      }
                      if (!value.startsWith('xoxb-')) {
                        return 'Slack token must start with "xoxb-"';
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
                          'How to get Slack Token:',
                          style: theme.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Create a Slack app and install it to your workspace',
                          style: theme.bodySmall,
                        ),
                        Text(
                          '• Copy the Bot User OAuth Token (starts with xoxb-)',
                          style: theme.bodySmall,
                        ),
                        Text(
                          '• Need help? Contact us at myjarvischat@gmail.com',
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final datasource = Datasource(
                    type: 'slack',
                    name: nameController.text.trim(),
                    credentials: {'token': tokenController.text.trim()},
                  );
                  final slackRequest = DatasourceRequest(
                    datasources: [datasource],
                  );
                  _model.setSlackDataSource(slackRequest);
                  Navigator.of(dialogContext).pop();
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

  Future<void> showImportConfluenceDialog() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController wikiPageUrlController = TextEditingController(
      text: 'https://example.atlassian.net/wiki',
    );
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController accessTokenController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final theme = JarvisTheme.of(context);

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Import Confluence Source', style: theme.titleMedium),
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
                        'Unit Name',
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
                      hintText: 'Enter Confluence unit name',
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
                        return 'Unit name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Confluence Wiki Page URL',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: wikiPageUrlController,
                    decoration: InputDecoration(
                      hintText: 'https://example.atlassian.net/wiki',
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
                        return 'Wiki page URL is required';
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
                  Row(
                    children: [
                      Text(
                        'Confluence Username',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Confluence username',
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
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Confluence Access Token',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: accessTokenController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Confluence access token',
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
                        return 'Access token is required';
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
                          'How to get Confluence Access Token:',
                          style: theme.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Log in to your Confluence account',
                          style: theme.bodySmall,
                        ),
                        Text(
                          '• Go to Profile > Personal Access Tokens > Create token',
                          style: theme.bodySmall,
                        ),
                        Text(
                          '• Copy the generated token and paste it here',
                          style: theme.bodySmall,
                        ),
                        Text(
                          '• Need help? Contact us at myjarvischat@gmail.com',
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final datasource = Datasource(
                    type: 'confluence',
                    name: nameController.text.trim(),
                    credentials: {
                      'url': wikiPageUrlController.text.trim(),
                      'username': usernameController.text.trim(),
                      'token': accessTokenController.text.trim(),
                    },
                  );
                  final confluenceRequest = DatasourceRequest(
                    datasources: [datasource],
                  );
                  _model.setConfluenceDataSource(confluenceRequest);
                  Navigator.of(dialogContext).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JarvisTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: JarvisTheme.of(context).primaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          'Create New Bot',
          style: JarvisTheme.of(context).headlineSmall.override(
            fontFamily: 'Inter Tight',
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: JarvisTheme.of(context).accent1,
                      shape: BoxShape.circle,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Icon(
                        Icons.smart_toy_rounded,
                        color: JarvisTheme.of(context).primary,
                        size: 48.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                  child: Text(
                    'Give your AI bot a name and personality to get started',
                    textAlign: TextAlign.center,
                    style: JarvisTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: JarvisTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bot Name',
                          style: JarvisTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _model.nameController,
                            focusNode: _model.NameFieldFocusNode,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Enter a name for your bot',
                              hintStyle: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: JarvisTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                              errorText: _model.nameError,
                              errorStyle: JarvisTheme.of(
                                context,
                              ).bodySmall.copyWith(
                                color: JarvisTheme.of(context).error,
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
                                  color: Color(0x00000000),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor:
                                  JarvisTheme.of(context).secondaryBackground,
                            ),
                            style: JarvisTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                            cursorColor: JarvisTheme.of(context).primary,
                            validator: _model.nameControllerValidator,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bot Description',
                          style: JarvisTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _model.descriptionController,
                            focusNode: _model.descriptionFieldFocusNode,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText:
                                  'Describe your bot\'s personality and behavior',
                              hintStyle: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: JarvisTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                              errorText: _model.descriptionError,
                              errorStyle: JarvisTheme.of(
                                context,
                              ).bodySmall.copyWith(
                                color: JarvisTheme.of(context).error,
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
                                  color: Color(0x00000000),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor:
                                  JarvisTheme.of(context).secondaryBackground,
                            ),
                            style: JarvisTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            cursorColor: JarvisTheme.of(context).primary,
                            validator: _model.descriptionControllerValidator,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bot Instruction',
                          style: JarvisTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _model.instructionController,
                            focusNode: _model.instructionFieldFocusNode,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Write instruction for your Bot',
                              errorText: _model.instructionError,
                              errorStyle: JarvisTheme.of(
                                context,
                              ).bodySmall.copyWith(
                                color: JarvisTheme.of(context).error,
                              ),
                              hintStyle: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
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
                                  color: Color(0x00000000),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor:
                                  JarvisTheme.of(context).secondaryBackground,
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
                      ],
                    ),
                    SizedBox(height: 24.0),
                    if (existingAssistant == null)
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Knowledge Sources',
                            style: JarvisTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter Tight',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    JarvisTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: JarvisTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
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
                                                JarvisTheme.of(
                                                  context,
                                                ).primaryText,
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                        JarvisIconButton(
                                          borderRadius: 20.0,
                                          buttonSize: 40.0,
                                          icon: Icon(
                                            Icons.add_circle_outline_rounded,
                                            color:
                                                JarvisTheme.of(context).primary,
                                            size: 24.0,
                                          ),
                                          onPressed: () {
                                            showAddKnowledgeUnitDialog(context);
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.0),
                                    Divider(
                                      height: 1.0,
                                      thickness: 1.0,
                                      color: JarvisTheme.of(context).alternate,
                                    ),
                                    SizedBox(height: 16.0),
                                    if (_model.fileError != null)
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          _model.fileError!,
                                          style: JarvisTheme.of(
                                            context,
                                          ).bodySmall.copyWith(
                                            color:
                                                JarvisTheme.of(context).error,
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 8.0),
                                    Observer(
                                      builder: (_) {
                                        bool hasFiles =
                                            _model.selectedFiles.isNotEmpty;
                                        bool hasSlack =
                                            _model.slackDataSource != null &&
                                            _model
                                                .slackDataSource!
                                                .datasources
                                                .isNotEmpty;
                                        bool hasConfluence =
                                            _model.confluenceDataSource !=
                                                null &&
                                            _model
                                                .confluenceDataSource!
                                                .datasources
                                                .isNotEmpty;
                                        bool hasNoSources =
                                            !hasFiles &&
                                            !hasSlack &&
                                            !hasConfluence;

                                        return hasNoSources
                                            ? Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        12.0,
                                                        0.0,
                                                        12.0,
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
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                if (hasFiles)
                                                  ..._model.selectedFiles.map((
                                                    file,
                                                  ) {
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
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
                                                                    EdgeInsetsDirectional.fromSTEB(
                                                                      12.0,
                                                                      0.0,
                                                                      12.0,
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
                                                                file.name,
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
                                                if (hasSlack)
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                    12.0,
                                                                    0.0,
                                                                    12.0,
                                                                    0.0,
                                                                  ),
                                                              child: Image(
                                                                image: AssetImage(
                                                                  'assets/Slack_icon.png',
                                                                ),
                                                                width: 24.0,
                                                                height: 24.0,
                                                              ),
                                                            ),
                                                            Text(
                                                              _model
                                                                  .slackDataSource!
                                                                  .datasources
                                                                  .first
                                                                  .name,
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
                                                                  .setSlackDataSource(
                                                                    null,
                                                                  );
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                if (hasConfluence)
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                    12.0,
                                                                    0.0,
                                                                    12.0,
                                                                    0.0,
                                                                  ),
                                                              child: Image(
                                                                image: AssetImage(
                                                                  'assets/confluence.png',
                                                                ),
                                                                width: 24.0,
                                                                height: 24.0,
                                                              ),
                                                            ),
                                                            Text(
                                                              _model
                                                                  .confluenceDataSource!
                                                                  .datasources
                                                                  .first
                                                                  .name,
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
                                                                  .setConfluenceDataSource(
                                                                    null,
                                                                  );
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () {
                      _handleAssistant();
                    },
                    text:
                        widget.existingAssistantId == null
                            ? 'Create Bot'
                            : 'Update Bot',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 56.0,
                      padding: EdgeInsets.all(8.0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                        0.0,
                        0.0,
                        0.0,
                        0.0,
                      ),
                      color: JarvisTheme.of(context).primary,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
