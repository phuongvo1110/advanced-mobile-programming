import 'package:flutter/material.dart';
import 'package:jarvis_ai/theme/flutter_flow_theme.dart';
import 'package:jarvis_ai/theme/form_field_controller.dart';
import 'package:jarvis_ai/theme/jarvis_drop_down.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

class AIBotsManagingPageModel {
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(String?)? textControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

class AiBotsManagingPage extends StatefulWidget {
  const AiBotsManagingPage({super.key});

  @override
  State<AiBotsManagingPage> createState() => _AIBotsManagingPageWidgetState();
}

class _AIBotsManagingPageWidgetState extends State<AiBotsManagingPage> {
  late AIBotsManagingPageModel _model;
  @override
  void initState() {
    super.initState();
    _model = AIBotsManagingPageModel();
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
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
          'AI Bots',
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
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
            child: JarvisIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: JarvisTheme.of(context).secondaryBackground,
                size: 30.0,
              ),
              onPressed: () async {
                // context.pushNamed(
                //   LoginScreenWidget.routeName,
                //   extra: <String, dynamic>{
                //     kTransitionInfoKey: TransitionInfo(
                //       hasTransition: true,
                //       transitionType: PageTransitionType.bottomToTop,
                //       duration: Duration(milliseconds: 200),
                //     ),
                //   },
                // );
              },
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Container(
              width: double.infinity,
              child: TextFormField(
                controller: _model.textController,
                focusNode: _model.textFieldFocusNode,
                autofocus: false,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Search assistants...',
                  hintStyle: JarvisTheme.of(context).labelMedium.override(
                    fontFamily: 'Inter',
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
                      color: JarvisTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: JarvisTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: JarvisTheme.of(context).secondaryBackground,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: JarvisTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                ),
                style: JarvisTheme.of(
                  context,
                ).bodyMedium.override(fontFamily: 'Inter', letterSpacing: 0.0),
                cursorColor: JarvisTheme.of(context).primaryText,
                validator: _model.textControllerValidator,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Assistants',
                  style: JarvisTheme.of(context).titleMedium.override(
                    fontFamily: 'Inter Tight',
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                JarvisDropDown<String>(
                  controller:
                      _model.dropDownValueController ??=
                          FormFieldController<String>(null),
                  options: ['Recent', 'Name', 'Type'],
                  onChanged: (val) => {},
                  width: 120.0,
                  height: 36.0,
                  textStyle: JarvisTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                  ),
                  hintText: 'Sort by',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: JarvisTheme.of(context).primaryText,
                    size: 20.0,
                  ),
                  fillColor: JarvisTheme.of(context).secondaryBackground,
                  elevation: 0.0,
                  borderColor: JarvisTheme.of(context).alternate,
                  borderWidth: 1.0,
                  borderRadius: 8.0,
                  margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  hidesUnderline: true,
                  isSearchable: false,
                  isMultiSelect: false,
                ),
              ],
            ),
          ),
          ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: JarvisTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: JarvisTheme.of(context).primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: JarvisTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Icon(
                              Icons.smart_toy_rounded,
                              color: JarvisTheme.of(context).info,
                              size: 30.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              12.0,
                              0.0,
                              12.0,
                              0.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Research Assistant',
                                  style: JarvisTheme.of(
                                    context,
                                  ).titleMedium.override(
                                    fontFamily: 'Inter Tight',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    4.0,
                                    0.0,
                                    0.0,
                                  ),
                                  child: Text(
                                    'Helps with academic research and citations',
                                    style: JarvisTheme.of(
                                      context,
                                    ).bodySmall.override(
                                      fontFamily: 'Inter',
                                      color:
                                          JarvisTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        JarvisIconButton(
                          borderRadius: 20.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.more_vert,
                            color: JarvisTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: JarvisTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: JarvisTheme.of(context).secondary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: JarvisTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Icon(
                              Icons.code_rounded,
                              color: JarvisTheme.of(context).info,
                              size: 30.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              12.0,
                              0.0,
                              12.0,
                              0.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Code Helper',
                                  style: JarvisTheme.of(
                                    context,
                                  ).titleMedium.override(
                                    fontFamily: 'Inter Tight',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    4.0,
                                    0.0,
                                    0.0,
                                  ),
                                  child: Text(
                                    'Assists with programming and debugging',
                                    style: JarvisTheme.of(
                                      context,
                                    ).bodySmall.override(
                                      fontFamily: 'Inter',
                                      color:
                                          JarvisTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        JarvisIconButton(
                          borderRadius: 20.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.more_vert,
                            color: JarvisTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: JarvisTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: JarvisTheme.of(context).tertiary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: JarvisTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Icon(
                              Icons.edit_note_rounded,
                              color: JarvisTheme.of(context).info,
                              size: 30.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              12.0,
                              0.0,
                              12.0,
                              0.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Writing Assistant',
                                  style: JarvisTheme.of(
                                    context,
                                  ).titleMedium.override(
                                    fontFamily: 'Inter Tight',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    4.0,
                                    0.0,
                                    0.0,
                                  ),
                                  child: Text(
                                    'Helps with content creation and editing',
                                    style: JarvisTheme.of(
                                      context,
                                    ).bodySmall.override(
                                      fontFamily: 'Inter',
                                      color:
                                          JarvisTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        JarvisIconButton(
                          borderRadius: 20.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.more_vert,
                            color: JarvisTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: JarvisTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: JarvisTheme.of(context).success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: JarvisTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Icon(
                              Icons.translate_rounded,
                              color: JarvisTheme.of(context).info,
                              size: 30.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              12.0,
                              0.0,
                              12.0,
                              0.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Language Translator',
                                  style: JarvisTheme.of(
                                    context,
                                  ).titleMedium.override(
                                    fontFamily: 'Inter Tight',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    4.0,
                                    0.0,
                                    0.0,
                                  ),
                                  child: Text(
                                    'Translates text between multiple languages',
                                    style: JarvisTheme.of(
                                      context,
                                    ).bodySmall.override(
                                      fontFamily: 'Inter',
                                      color:
                                          JarvisTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        JarvisIconButton(
                          borderRadius: 20.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.more_vert,
                            color: JarvisTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: JarvisTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: JarvisTheme.of(context).warning,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: JarvisTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Icon(
                              Icons.psychology_alt_rounded,
                              color: JarvisTheme.of(context).info,
                              size: 30.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              12.0,
                              0.0,
                              12.0,
                              0.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Creative Companion',
                                  style: JarvisTheme.of(
                                    context,
                                  ).titleMedium.override(
                                    fontFamily: 'Inter Tight',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    4.0,
                                    0.0,
                                    0.0,
                                  ),
                                  child: Text(
                                    'Generates creative ideas and inspiration',
                                    style: JarvisTheme.of(
                                      context,
                                    ).bodySmall.override(
                                      fontFamily: 'Inter',
                                      color:
                                          JarvisTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        JarvisIconButton(
                          borderRadius: 20.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.more_vert,
                            color: JarvisTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                child: FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: 'Create New Assistant',
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
    );
  }
}
