import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

class AIChatMessageModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(String?)? textControllerValidator;
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

class AIMessagePage extends StatefulWidget {
  const AIMessagePage({super.key});
  @override
  State<AIMessagePage> createState() => _AIMessagePageWidgetState();
}

class _AIMessagePageWidgetState extends State<AIMessagePage> {
  late AIChatMessageModel _model;
  @override
  void initState() {
    super.initState();
    _model = AIChatMessageModel();

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
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
            child: JarvisIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: FaIcon(
                FontAwesomeIcons.solidCircleUser,
                color: JarvisTheme.of(context).primaryText,
                size: 30.0,
              ),
              onPressed: () async {},
            ),
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
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 80.0),
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                    scrollDirection: Axis.vertical,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          decoration: BoxDecoration(
                            color: JarvisTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Hello! How can I assist you today?',
                              style: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Align(
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          decoration: BoxDecoration(
                            color: JarvisTheme.of(context).secondary,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Can you help me find information about climate change?',
                              style: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: JarvisTheme.of(context).info,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.75,
                          decoration: BoxDecoration(
                            color: JarvisTheme.of(context).secondaryBackground,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Of course! Climate change refers to long-term shifts in temperatures and weather patterns. These shifts may be natural, but since the 1800s, human activities have been the main driver of climate change, primarily due to the burning of fossil fuels like coal, oil, and gas, which produces heat-trapping gases. Would you like to know more about its causes, effects, or potential solutions?',
                              style: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
          ),
        ],
      ),
    );
  }
}
