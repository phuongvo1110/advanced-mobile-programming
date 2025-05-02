import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jarvis_ai/models/assistant.dart';
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
  // State field(s) for TextField widget.
  FocusNode? descriptionFieldFocusNode;
  TextEditingController? descriptionController;
  String? Function(String?)? descriptionControllerValidator;
  // State field(s) for DropDown widget.
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
      if (widget.existingAssistantId == null) {
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
                                            _pickFile();
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
                                      builder:
                                          (_) =>
                                              _model.selectedFiles.isEmpty
                                                  ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
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
                                                                EdgeInsets.symmetric(
                                                                  vertical: 8.0,
                                                                ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
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
                                                                        size:
                                                                            24.0,
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
                                                                  borderRadius:
                                                                      20.0,
                                                                  buttonSize:
                                                                      40.0,
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
