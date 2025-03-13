import 'package:flutter/material.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/flutter_flow_theme.dart';
import 'package:jarvis_ai/theme/flutter_flow_util.dart';
import 'package:jarvis_ai/theme/form_field_controller.dart';
import 'package:jarvis_ai/theme/jarvis_drop_down.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

class PromptCreatingPageModel
    extends FlutterFlowModel<PromptCreatingPage> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for SwitchListTile widget.
  bool? switchListTileValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}

class PromptCreatingPage extends StatefulWidget {
  const PromptCreatingPage({super.key});
  @override
  State<StatefulWidget> createState() => _PrompCreatingPageWidgetState();
}

class _PrompCreatingPageWidgetState extends State<PromptCreatingPage> {
  late PromptCreatingPageModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PromptCreatingPageModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
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
                          style: JarvisTheme.of(
                            context,
                          ).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _model.textController1,
                            focusNode: _model.textFieldFocusNode1,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Enter a decriptive title',
                              hintStyle: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                color:
                                    JarvisTheme.of(context).secondaryText,
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
                                  JarvisTheme.of(
                                    context,
                                  ).secondaryBackground,
                            ),
                            style: JarvisTheme.of(
                              context,
                            ).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                            cursorColor: JarvisTheme.of(context).primary,
                            validator: _model.textController1Validator
                                .asValidator(context),
                          ),
                        ),
                      ]
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prompt Content',
                          style: JarvisTheme.of(
                            context,
                          ).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _model.textController2,
                            focusNode: _model.textFieldFocusNode2,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Write your prompt here...',
                              hintStyle: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                color:
                                    JarvisTheme.of(context).secondaryText,
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
                                  JarvisTheme.of(
                                    context,
                                  ).secondaryBackground,
                            ),
                            style: JarvisTheme.of(
                              context,
                            ).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            cursorColor: JarvisTheme.of(context).primary,
                            validator: _model.textController2Validator
                                .asValidator(context),
                          ),
                        ),
                      ]
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category',
                          style: JarvisTheme.of(
                            context,
                          ).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        JarvisDropDown<String>(
                          controller:
                              _model.dropDownValueController ??=
                                  FormFieldController<String>(null),
                          options: [
                            'Customer Support',
                            'Personal Assistant',
                            'Knowledge Base',
                            'Creative Writing',
                            'Other',
                          ],
                          onChanged:
                              (val) => safeSetState(
                                () => _model.dropDownValue = val,
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
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tags (comma seperate)',
                          style: JarvisTheme.of(
                            context,
                          ).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _model.textController3,
                            focusNode: _model.textFieldFocusNode3,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'ai, writing, creative, etc.',
                              hintStyle: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                color:
                                    JarvisTheme.of(context).secondaryText,
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
                                  JarvisTheme.of(
                                    context,
                                  ).secondaryBackground,
                            ),
                            style: JarvisTheme.of(
                              context,
                            ).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                            cursorColor: JarvisTheme.of(context).primary,
                            validator: _model.textController3Validator
                                .asValidator(context),
                          ),
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: SwitchListTile.adaptive(
                        value: _model.switchListTileValue ??= true,
                        onChanged: (newValue) async {
                          safeSetState(
                            () => _model.switchListTileValue = newValue!,
                          );
                        },
                        title: Text(
                          'Public',
                          style: JarvisTheme.of(
                            context,
                          ).titleLarge.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                          ),
                        ),
                        subtitle: Text(
                          'Make this prompt public or private',
                          style: JarvisTheme.of(
                            context,
                          ).labelMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                        ),
                        tileColor:
                            JarvisTheme.of(context).primaryBackground,
                        activeColor: JarvisTheme.of(context).alternate,
                        activeTrackColor: JarvisTheme.of(context).primary,
                        dense: false,
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                    ),
                  ].divide(SizedBox(height: 24.0)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: 'Create Bot',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
