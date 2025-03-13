import 'package:flutter/material.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

class CardPromtModel extends FlutterFlowModel<CardPromtWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}


class CardPromtWidget extends StatefulWidget {
  const CardPromtWidget({super.key});

  @override
  State<CardPromtWidget> createState() => _CardPromtWidgetState();
}

class _CardPromtWidgetState extends State<CardPromtWidget> {
  late CardPromtModel _model;
  @override
  void initState() {
    super.initState();
    _model = CardPromtModel();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: JarvisTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                child: Text(
                  'Data Analysis Expert',
                  style: JarvisTheme.of(context).titleLarge.override(
                    fontFamily: 'Inter Tight',
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                child: Text(
                  'You are a data analaysis expert who helps users interpret complex datasets. Provide clear explanation of statistical concempts and guid',
                  style: JarvisTheme.of(context).labelMedium.override(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.explicit,
                      color: JarvisTheme.of(context).secondaryText,
                      size: 24.0,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        8.0,
                        0.0,
                        0.0,
                        0.0,
                      ),
                      child: Text(
                        'Mar 25 • 3 hr, 32 min',
                        style: JarvisTheme.of(context).labelMedium.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  JarvisIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      Icons.edit,
                      color: JarvisTheme.of(context).secondaryText,
                      size: 20.0,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      12.0,
                      0.0,
                      0.0,
                      0.0,
                    ),
                    child: JarvisIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.delete,
                        color: JarvisTheme.of(context).error,
                        size: 20.0,
                      ),
                      onPressed: () {
                        print('IconButton pressed ...');
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      12.0,
                      0.0,
                      0.0,
                      0.0,
                    ),
                    child: JarvisIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.keyboard_control,
                        color: JarvisTheme.of(context).secondaryText,
                        size: 20.0,
                      ),
                      onPressed: () {
                        print('IconButton pressed ...');
                      },
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional(1.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          12.0,
                          0.0,
                          0.0,
                          0.0,
                        ),
                        child: JarvisIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30.0,
                          borderWidth: 1.0,
                          buttonSize: 40.0,
                          fillColor: JarvisTheme.of(context).secondary,
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          onPressed: () {
                            print('IconButton pressed ...');
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
