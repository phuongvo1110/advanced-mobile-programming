import 'package:flutter/material.dart';
import 'package:jarvis_ai/theme/flutter_flow_theme.dart';
import 'package:jarvis_ai/theme/form_field_controller.dart';
import 'package:jarvis_ai/theme/jarvis_drop_down.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

class AIBotCreatePageModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(String?)? textController2Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}

class AIBotCreatePageWidget extends StatefulWidget {
  const AIBotCreatePageWidget({super.key});
  @override
  State<AIBotCreatePageWidget> createState() => _AIBotCreaePageWidgetState();
}

class _AIBotCreaePageWidgetState extends State<AIBotCreatePageWidget> {
  late AIBotCreatePageModel _model;
  @override
  void initState() {
    super.initState();
    _model = AIBotCreatePageModel();

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                            controller: _model.textController1,
                            focusNode: _model.textFieldFocusNode1,
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
                            validator: _model.textController1Validator,
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
                          'Bot Personality',
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
                            controller: _model.textController2,
                            focusNode: _model.textFieldFocusNode2,
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
                            validator: _model.textController2Validator,
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
                          'Bot Category',
                          style: JarvisTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0),
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
                          onChanged: (val) => {},
                          // {safeSetState(() => _model.dropDownValue = val)},
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
                      ],
                    ),
                    SizedBox(height: 24.0),
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
                                          print('IconButton pressed ...');
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
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
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
