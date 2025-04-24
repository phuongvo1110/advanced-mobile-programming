import 'package:flutter/material.dart';
import 'package:jarvis_ai/models/prompt.dart';
import 'package:jarvis_ai/services/jarvis_service.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/flutter_flow_theme.dart';
import 'package:jarvis_ai/theme/flutter_flow_util.dart';
import 'package:jarvis_ai/theme/form_field_controller.dart';
import 'package:jarvis_ai/theme/jarvis_drop_down.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class PromptCreatingPageModel extends FlutterFlowModel<PromptCreatingPage> {
  /// State fields for stateful widgets in this page
  FocusNode? titleFieldFocusNode;
  TextEditingController? titleController;
  FocusNode? descriptionFieldFocusNode;
  TextEditingController? descriptionController;
  FocusNode? contentFieldFocusNode;
  TextEditingController? contentController;
  String? categoryDropdownValue;
  FormFieldController<String>? categoryDropdownValueController;
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  bool? switchIsPublic;

  // Observable error states
  @observable
  String? titleError;
  @observable
  String? descriptionError;
  @observable
  String? contentError;
  @observable
  String? tagsError;

  // Validation functions
  void validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      titleError = 'Title is required';
    } else if (value.length > 100) {
      titleError = 'Title must be less than 100 characters';
    } else {
      titleError = null;
    }
  }

  void validateDescription(String? value) {
    if (value != null && value.length > 200) {
      descriptionError = 'Description must be less than 200 characters';
    } else {
      descriptionError = null;
    }
  }

  void validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      contentError = 'Content is required';
    } else if (value.length > 5000) {
      contentError = 'Content must be less than 5000 characters';
    } else {
      contentError = null;
    }
  }

  void validateTags(String? value) {
    if (value != null && value.length > 100) {
      tagsError = 'Tags must be less than 100 characters';
    } else {
      tagsError = null;
    }
  }

  bool validateAll() {
    validateTitle(titleController?.text);
    validateDescription(descriptionController?.text);
    validateContent(contentController?.text);
    validateTags(textController3?.text);

    return titleError == null &&
        descriptionError == null &&
        contentError == null &&
        tagsError == null;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    titleFieldFocusNode?.dispose();
    titleController?.dispose();
    descriptionFieldFocusNode?.dispose();
    descriptionController?.dispose();
    contentFieldFocusNode?.dispose();
    contentController?.dispose();
    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}

class PromptCreatingPage extends StatefulWidget {
  const PromptCreatingPage({
    super.key,
    required this.apiStore,
    this.existingPrompt,
  });
  final ApiStore apiStore;
  final Prompt? existingPrompt;
  @override
  State<StatefulWidget> createState() => _PrompCreatingPageWidgetState();
}

class _PrompCreatingPageWidgetState extends State<PromptCreatingPage> {
  late PromptCreatingPageModel _model;
  bool _isCreating = false;
  @override
  void initState() {
    super.initState();
    _model = PromptCreatingPageModel();
    _model.titleController ??= TextEditingController();
    _model.titleFieldFocusNode ??= FocusNode();
    _model.descriptionController ??= TextEditingController();
    _model.descriptionFieldFocusNode ??= FocusNode();
    _model.contentController ??= TextEditingController();
    _model.contentFieldFocusNode ??= FocusNode();
    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.categoryDropdownValueController ??= FormFieldController<String>(
      widget.existingPrompt?.category?.toUpperCase(),
    );
    final initialCategory = widget.existingPrompt?.category?.toUpperCase();
    _model.categoryDropdownValueController ??= FormFieldController<String>(
      initialCategory != null && initialCategory.isNotEmpty
          ? initialCategory
          : null,
    );
    // Then set values if existing prompt exists
    print('existingPrompt: ${widget.existingPrompt?.userId} && ');
    if (widget.existingPrompt != null) {
      _model.titleController.text = widget.existingPrompt!.title;
      _model.descriptionController.text =
          widget.existingPrompt!.description ?? '';
      _model.contentController.text = widget.existingPrompt!.content;
      _model.switchIsPublic = widget.existingPrompt!.isPublic;
      _model.categoryDropdownValue =
          widget.existingPrompt!.category?.toUpperCase();
    }
  }

  Future<void> _createPrompt() async {
    if (widget.existingPrompt != null &&
        widget.apiStore.authService.currentUser?.userId !=
            widget.existingPrompt!.userId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only edit your own prompts')),
      );
      return;
    }
    if (!_model.validateAll()) {
      setState(() {});
      return;
    }
    if (_isCreating) return;
    setState(() {
      _isCreating = true;
    });
    try {
      final prompt =
          widget.existingPrompt == null
              ? await widget.apiStore.jarvisService.createPrompt(
                title: _model.titleController.text,
                content: _model.contentController.text,
                description: _model.descriptionController.text,
                isPublic: _model.switchIsPublic ?? true,
                category: _model.categoryDropdownValue ?? 'OTHER',
              )
              : {
                await widget.apiStore.jarvisService.updatePrompt(
                  id: widget.existingPrompt!.id,
                  title: _model.titleController.text,
                  content: _model.contentController.text,
                  description: _model.descriptionController.text,
                  isPublic: _model.switchIsPublic ?? true,
                  category: _model.categoryDropdownValue,
                ),
              };
      ;
      if (widget.existingPrompt == null && prompt != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Prompt created successfully!')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Prompt updated successfully!')));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create prompt: $e')));
    } finally {
      setState(() {
        _isCreating = false;
      });
    }
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
        backgroundColor: JarvisTheme.of(context).primaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          'Create New Prompt',
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
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prompt title',
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
                            controller: _model.titleController,
                            focusNode: _model.titleFieldFocusNode,
                            autofocus: false,
                            obscureText: false,
                            onChanged: (value) => _model.validateTitle(value),
                            decoration: InputDecoration(
                              hintText: 'Enter a decriptive title',
                              hintStyle: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: JarvisTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                              errorText: _model.titleError,
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
                            validator: null,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prompt description',
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
                            onChanged:
                                (value) => _model.validateDescription(value),
                            decoration: InputDecoration(
                              hintText: 'Enter a description',
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
                            cursorColor: JarvisTheme.of(context).primary,
                            validator: null,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prompt Content',
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
                            controller: _model.contentController,
                            focusNode: _model.contentFieldFocusNode,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Write your prompt here...',
                              hintStyle: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: JarvisTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                              errorText: _model.contentError,
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
                            onChanged: (value) => _model.validateContent(value),
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            cursorColor: JarvisTheme.of(context).primary,
                            validator: null,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category',
                          style: JarvisTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        JarvisDropDown<String>(
                          controller:
                              _model.categoryDropdownValueController ??=
                                  FormFieldController<String>(null),
                          options: [
                            'BUSINESS',
                            'CAREER',
                            'CHATBOT',
                            'CODING',
                            'EDUCATION',
                            'FUN',
                            'MARKETING',
                            'PRODUCTIVITY',
                            'SEO',
                            'WRITING',
                            'OTHER',
                          ],
                          onChanged:
                              (val) => safeSetState(
                                () => _model.categoryDropdownValue = val,
                              ),
                          width: double.infinity,
                          height: 56.0,
                          textStyle: JarvisTheme.of(
                            context,
                          ).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                          hintText: 'Select a category',
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: JarvisTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                          fillColor:
                              JarvisTheme.of(context).secondaryBackground,
                          elevation: 2.0,
                          borderColor: JarvisTheme.of(context).alternate,
                          borderWidth: 1.0,
                          borderRadius: 12.0,
                          margin: EdgeInsetsDirectional.fromSTEB(
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          hidesUnderline: true,
                          isSearchable: false,
                          isMultiSelect: false,
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: SwitchListTile.adaptive(
                        value: _model.switchIsPublic ??= true,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchIsPublic = newValue!);
                        },
                        title: Text(
                          'Public',
                          style: JarvisTheme.of(context).titleLarge.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                          ),
                        ),
                        subtitle: Text(
                          'Make this prompt public or private',
                          style: JarvisTheme.of(context).labelMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                        ),
                        tileColor: JarvisTheme.of(context).primaryBackground,
                        activeColor: JarvisTheme.of(context).alternate,
                        activeTrackColor: JarvisTheme.of(context).primary,
                        dense: false,
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                    ),
                  ].divide(SizedBox(height: 24.0)),
                ),
                // Text(
                //   widget.existingPrompt == null ||
                //           (widget.apiStore.authService.currentUser?.userId !=
                //                   null &&
                //               widget.existingPrompt!.userId ==
                //                   widget
                //                       .apiStore
                //                       .authService
                //                       .currentUser!
                //                       .userId)
                //       ? 'You can only edit your own prompt'
                //       : '',
                //       style: TextStyle(color: Color(0x00000000))),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: _createPrompt,
                    isEnabled:
                        widget.existingPrompt == null ||
                        (widget.apiStore.authService.currentUser?.userId !=
                                null &&
                            widget.existingPrompt!.userId ==
                                widget
                                    .apiStore
                                    .authService
                                    .currentUser!
                                    .userId),
                    text:
                        widget.existingPrompt == null
                            ? 'Create Prompt'
                            : 'Update Prompt',
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
