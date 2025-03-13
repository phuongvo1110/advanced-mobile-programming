import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jarvis_ai/pages/ai_subscribtion_page.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/flutter_flow_theme.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';
import 'package:provider/provider.dart';

class SubscribtionWidget extends StatefulWidget {
  const SubscribtionWidget({super.key});

  @override
  State<SubscribtionWidget> createState() => _SubscribtionWidgetState();
}

class _SubscribtionWidgetState extends State<SubscribtionWidget> {
  late SubscribtionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscribtionModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: JarvisTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 4.0,
                color: Color(0x33000000),
                offset: Offset(0.0, 2.0),
                spreadRadius: 0.0,
              ),
            ],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Premium Plan',
                          style: JarvisTheme.of(context).headlineSmall.override(
                            fontFamily: 'Inter Tight',
                            color: JarvisTheme.of(context).secondary,
                            letterSpacing: 0.0,
                          ),
                        ),
                        Text(
                          '\$9.99/month',
                          style: JarvisTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter Tight',
                            color: JarvisTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: JarvisTheme.of(context).accent1,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: JarvisTheme.of(context).primary,
                          width: 2.0,
                        ),
                      ),
                      child: Icon(
                        Icons.workspace_premium,
                        color: JarvisTheme.of(context).primary,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Features Included:',
                      style: JarvisTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: JarvisTheme.of(context).success,
                          size: 20.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Unlimited conversations',
                          style: JarvisTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: JarvisTheme.of(context).success,
                          size: 20.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Priority support',
                          style: JarvisTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: JarvisTheme.of(context).success,
                          size: 20.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Advanced AI features',
                          style: JarvisTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                        ),
                      ]
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: JarvisTheme.of(context).success,
                          size: 20.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'No ads experience',
                          style: JarvisTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                        ),
                      ]
                    ),
                  ]
                ),
                SizedBox(height: 16.0),
                FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: 'Subscribe Now',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 48.0,
                    padding: EdgeInsets.all(8.0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                      0.0,
                      0.0,
                      0.0,
                      0.0,
                    ),
                    color: JarvisTheme.of(context).secondary,
                    textStyle: JarvisTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter Tight',
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                SizedBox(height: 16.0),
                RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'By subscribing, you agree to our ',
                        style: JarvisTheme.of(context).bodySmall.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                        ),
                      ),
                      TextSpan(
                        text: 'Terms of Service',
                        style: JarvisTheme.of(context).bodySmall.override(
                          fontFamily: 'Inter',
                          color: JarvisTheme.of(context).primary,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                    style: JarvisTheme.of(context).bodySmall.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
