import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jarvis_ai/theme/flutter_flow_animations.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/flutter_flow_theme.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';
import 'package:provider/provider.dart';

class ProfilePageModel extends FlutterFlowModel<ProfilePage> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static String routeName = 'ProfilePage';
  static String routePath = '/profilePage';

  @override
  State<ProfilePage> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late ProfilePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilePageModel());

    animationsMap.addAll({
      'cardOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder:
            () => [
              VisibilityEffect(duration: 1.ms),
              FadeEffect(
                curve: Curves.easeInOut,
                delay: 0.0.ms,
                duration: 600.0.ms,
                begin: 0.0,
                end: 1.0,
              ),
              ScaleEffect(
                curve: Curves.easeInOut,
                delay: 0.0.ms,
                duration: 600.0.ms,
                begin: Offset(0.6, 0.6),
                end: Offset(1.0, 1.0),
              ),
            ],
      ),
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder:
            () => [
              VisibilityEffect(duration: 1.ms),
              FadeEffect(
                curve: Curves.easeInOut,
                delay: 0.0.ms,
                duration: 600.0.ms,
                begin: 0.0,
                end: 1.0,
              ),
              MoveEffect(
                curve: Curves.easeInOut,
                delay: 0.0.ms,
                duration: 600.0.ms,
                begin: Offset(0.0, 20.0),
                end: Offset(0.0, 0.0),
              ),
            ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder:
            () => [
              VisibilityEffect(duration: 1.ms),
              FadeEffect(
                curve: Curves.easeInOut,
                delay: 0.0.ms,
                duration: 600.0.ms,
                begin: 0.0,
                end: 1.0,
              ),
              MoveEffect(
                curve: Curves.easeInOut,
                delay: 0.0.ms,
                duration: 600.0.ms,
                begin: Offset(0.0, 20.0),
                end: Offset(0.0, 0.0),
              ),
            ],
      ),
      'dividerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder:
            () => [
              VisibilityEffect(duration: 1.ms),
              FadeEffect(
                curve: Curves.easeInOut,
                delay: 0.0.ms,
                duration: 600.0.ms,
                begin: 0.0,
                end: 1.0,
              ),
              MoveEffect(
                curve: Curves.easeInOut,
                delay: 0.0.ms,
                duration: 600.0.ms,
                begin: Offset(0.0, 20.0),
                end: Offset(0.0, 0.0),
              ),
            ],
      ),
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder:
            () => [
              VisibilityEffect(duration: 1.ms),
              FadeEffect(
                curve: Curves.easeInOut,
                delay: 0.0.ms,
                duration: 600.0.ms,
                begin: 0.0,
                end: 1.0,
              ),
              MoveEffect(
                curve: Curves.easeInOut,
                delay: 0.0.ms,
                duration: 600.0.ms,
                begin: Offset(0.0, 60.0),
                end: Offset(0.0, 0.0),
              ),
            ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder:
            () => [
              VisibilityEffect(duration: 200.ms),
              FadeEffect(
                curve: Curves.easeInOut,
                delay: 200.0.ms,
                duration: 600.0.ms,
                begin: 0.0,
                end: 1.0,
              ),
              MoveEffect(
                curve: Curves.easeInOut,
                delay: 200.0.ms,
                duration: 600.0.ms,
                begin: Offset(0.0, 60.0),
                end: Offset(0.0, 0.0),
              ),
            ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder:
            () => [
              VisibilityEffect(duration: 300.ms),
              FadeEffect(
                curve: Curves.easeInOut,
                delay: 300.0.ms,
                duration: 600.0.ms,
                begin: 0.0,
                end: 1.0,
              ),
              MoveEffect(
                curve: Curves.easeInOut,
                delay: 300.0.ms,
                duration: 600.0.ms,
                begin: Offset(0.0, 60.0),
                end: Offset(0.0, 0.0),
              ),
            ],
      ),
      'buttonOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder:
            () => [
              VisibilityEffect(duration: 400.ms),
              FadeEffect(
                curve: Curves.easeInOut,
                delay: 400.0.ms,
                duration: 600.0.ms,
                begin: 0.0,
                end: 1.0,
              ),
              MoveEffect(
                curve: Curves.easeInOut,
                delay: 400.0.ms,
                duration: 600.0.ms,
                begin: Offset(0.0, 60.0),
                end: Offset(0.0, 0.0),
              ),
            ],
      ),
    });
    setupAnimations(
      animationsMap.values.where(
        (anim) =>
            anim.trigger == AnimationTrigger.onActionTrigger ||
            !anim.applyInitialState,
      ),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: JarvisTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: JarvisTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
              child: JarvisIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.close_rounded,
                  color: JarvisTheme.of(context).secondaryText,
                  size: 30.0,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: JarvisTheme.of(context).primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1592520113018-180c8bc831c9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTI3fHxwcm9maWxlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ).animateOnPageLoad(animationsMap['cardOnPageLoadAnimation']!),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                child: Text(
                  'Andrea Davis',
                  style: JarvisTheme.of(context).headlineSmall.override(
                    fontFamily: 'Inter Tight',
                    letterSpacing: 0.0,
                  ),
                ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation1']!),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                child: Text(
                  'andrea@domainname.com',
                  style: JarvisTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter Tight',
                    color: JarvisTheme.of(context).secondary,
                    letterSpacing: 0.0,
                  ),
                ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation2']!),
              ),
              Divider(
                height: 44.0,
                thickness: 1.0,
                indent: 24.0,
                endIndent: 24.0,
                color: JarvisTheme.of(context).alternate,
              ).animateOnPageLoad(animationsMap['dividerOnPageLoadAnimation']!),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: JarvisTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: JarvisTheme.of(context).alternate,
                      width: 2.0,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      8.0,
                      12.0,
                      8.0,
                      12.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/premium');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              8.0,
                              0.0,
                              0.0,
                              0.0,
                            ),
                            child: Icon(
                              Icons.attach_money_sharp,
                              color: JarvisTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                          ),
                          Text(
                            'Premium',
                            style: JarvisTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animateOnPageLoad(
                  animationsMap['containerOnPageLoadAnimation1']!,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: JarvisTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: JarvisTheme.of(context).alternate,
                      width: 2.0,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      8.0,
                      12.0,
                      8.0,
                      12.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            8.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          child: Icon(
                            Icons.account_circle_outlined,
                            color: JarvisTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            12.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          child: Text(
                            'Edit Profile',
                            style: JarvisTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animateOnPageLoad(
                  animationsMap['containerOnPageLoadAnimation2']!,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: JarvisTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: JarvisTheme.of(context).alternate,
                      width: 2.0,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      8.0,
                      12.0,
                      8.0,
                      12.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            8.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          child: Icon(
                            Icons.settings_outlined,
                            color: JarvisTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            12.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          child: Text(
                            'Account Settings',
                            style: JarvisTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animateOnPageLoad(
                  animationsMap['containerOnPageLoadAnimation3']!,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    // GoRouter.of(context).prepareAuthEvent();
                    // await authManager.signOut();
                    // GoRouter.of(context).clearRedirectLocation();

                    // context.goNamedAuth(
                    //     LoginScreenWidget.routeName, context.mounted);
                  },
                  text: 'Log Out',
                  options: FFButtonOptions(
                    width: 150.0,
                    height: 44.0,
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                      0.0,
                      0.0,
                      0.0,
                      0.0,
                    ),
                    color: JarvisTheme.of(context).primaryBackground,
                    textStyle: JarvisTheme.of(context).bodyLarge.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: JarvisTheme.of(context).alternate,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(38.0),
                  ),
                ).animateOnPageLoad(
                  animationsMap['buttonOnPageLoadAnimation']!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
