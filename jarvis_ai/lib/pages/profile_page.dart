import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jarvis_ai/models/member.dart';
import 'package:jarvis_ai/models/token.dart';
import 'package:jarvis_ai/stores/api_store.dart';
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
  const ProfilePage({super.key, required this.apiStore});
  final ApiStore apiStore;

  @override
  State<ProfilePage> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late ProfilePageModel _model;
  Member? member;
  bool _isLoading = false;
  Token? usageToken;
  Future<void> fetchUsage() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final token = await widget.apiStore.jarvisService.getUsage();
      if (token != null && mounted) {
        setState(() {
          usageToken = token;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load usage data: $e')),
        );
      }
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilePageModel());
    _loadMemberData();
    fetchUsage();
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
      'containerOnPageLoadAnimation4': AnimationInfo(
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
      'containerOnPageLoadAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder:
            () => [
              VisibilityEffect(duration: 500.ms),
              FadeEffect(
                curve: Curves.easeInOut,
                delay: 500.0.ms,
                duration: 600.0.ms,
                begin: 0.0,
                end: 1.0,
              ),
              MoveEffect(
                curve: Curves.easeInOut,
                delay: 500.0.ms,
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
              VisibilityEffect(duration: 600.ms),
              FadeEffect(
                curve: Curves.easeInOut,
                delay: 600.0.ms,
                duration: 600.0.ms,
                begin: 0.0,
                end: 1.0,
              ),
              MoveEffect(
                curve: Curves.easeInOut,
                delay: 600.0.ms,
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

  Future<void> _loadMemberData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final member = await widget.apiStore.jarvisService.getCurrentUser();
      if (member != null && mounted) {
        setState(() {
          this.member = member;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load user data: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final member = this.member ?? widget.apiStore.jarvisService.member;
    String usernameInitial =
        member?.username?.isNotEmpty == true ? member!.username![0] : 'G';
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
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
          child: SingleChildScrollView(
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
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        color: Color(
                          (Random().nextDouble() * 0xFFFFFF).toInt(),
                        ).withOpacity(1.0),
                        child: Center(
                          child: Text(
                            usernameInitial,
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ).animateOnPageLoad(animationsMap['cardOnPageLoadAnimation']!),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: Text(
                    member?.username ?? 'Guest',
                    style: JarvisTheme.of(context).headlineSmall.override(
                      fontFamily: 'Inter Tight',
                      letterSpacing: 0.0,
                    ),
                  ).animateOnPageLoad(
                    animationsMap['textOnPageLoadAnimation1']!,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                  child: Text(
                    member?.email ?? 'No email',
                    style: JarvisTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter Tight',
                      color: JarvisTheme.of(context).secondary,
                      letterSpacing: 0.0,
                    ),
                  ).animateOnPageLoad(
                    animationsMap['textOnPageLoadAnimation2']!,
                  ),
                ),
                Divider(
                  height: 44.0,
                  thickness: 1.0,
                  indent: 24.0,
                  endIndent: 24.0,
                  color: JarvisTheme.of(context).alternate,
                ).animateOnPageLoad(
                  animationsMap['dividerOnPageLoadAnimation']!,
                ),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0,
                                  0.0,
                                  0.0,
                                  0.0,
                                ),
                                child: Icon(
                                  Icons.info_outline,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Plan: ${usageToken != null && usageToken!.unlimited ? 'Unlimited' : 'Free'}',
                                      style: JarvisTheme.of(
                                        context,
                                      ).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                    Text(
                                      usageToken != null && usageToken!.unlimited
                                          ? 'Unlimited Queries'
                                          : 'Limited Queries ${usageToken != null ? usageToken!.availableTokens : '0'}',
                                      style: JarvisTheme.of(
                                        context,
                                      ).bodySmall.override(
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
                              ),
                            ],
                          ),
                          FFButtonWidget(
                            onPressed: () {
                              Navigator.pushNamed(context, '/premium');
                            },
                            text: 'Upgrade',
                            options: FFButtonOptions(
                              width: 80.0,
                              height: 30.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                              ),
                              color: Color(0xFF6D28D9),
                              textStyle: JarvisTheme.of(
                                context,
                              ).bodySmall.override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                              elevation: 0.0,
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation1']!,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    16.0,
                    12.0,
                    16.0,
                    0.0,
                  ),
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
                              Icons.star_border,
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
                              'Unlimited AI Models',
                              style: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: JarvisTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                  ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation2']!,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    16.0,
                    12.0,
                    16.0,
                    0.0,
                  ),
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
                              Icons.group_work,
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
                              'Agent & Multi-agent Capacity',
                              style: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: JarvisTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                  ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation3']!,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    16.0,
                    12.0,
                    16.0,
                    0.0,
                  ),
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
                              Icons.storage,
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
                              'Knowledge Integration',
                              style: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: JarvisTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                  ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation4']!,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    16.0,
                    12.0,
                    16.0,
                    0.0,
                  ),
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
                              Icons.autorenew,
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
                              'Browser Tasks Automation',
                              style: JarvisTheme.of(
                                context,
                              ).bodyMedium.override(
                                fontFamily: 'Inter',
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: JarvisTheme.of(context).secondaryText,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                  ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation5']!,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      await widget.apiStore.authService.logout();
                      widget.apiStore.jarvisService.member = null;
                      Navigator.pushNamed(context, '/login');
                    },
                    text: 'Log Out',
                    options: FFButtonOptions(
                      width: 150.0,
                      height: 44.0,
                      padding: EdgeInsetsDirectional.fromSTEB(
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
      ),
    );
  }
}
