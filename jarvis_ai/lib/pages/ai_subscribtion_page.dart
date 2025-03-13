import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/flutter_flow_util.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

import '/components/subscribtion_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SubscribtionModel extends FlutterFlowModel<SubscribtionWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class AISubscribtionPageModel
    extends FlutterFlowModel<AISubscribtionPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Subscribtion component.
  late SubscribtionModel subscribtionModel;

  @override
  void initState(BuildContext context) {
    subscribtionModel = createModel(context, () => SubscribtionModel());
  }

  @override
  void dispose() {
    subscribtionModel.dispose();
  }
}

class AISubscribtionPageWidget extends StatefulWidget {
  const AISubscribtionPageWidget({super.key});

  static String routeName = 'AISubscribtionPage';
  static String routePath = '/aISubscribtionPage';

  @override
  State<AISubscribtionPageWidget> createState() =>
      _AISubscribtionPageWidgetState();
}

class _AISubscribtionPageWidgetState extends State<AISubscribtionPageWidget> {
  late AISubscribtionPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AISubscribtionPageModel());
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
        key: scaffoldKey,
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
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Premium',
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
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Upgrade Premium',
                style: JarvisTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  fontSize: 26.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Unlock all features and enjoy an ad-free experience',
                style: JarvisTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: JarvisTheme.of(context).alternate,
                  letterSpacing: 0.0,
                ),
              ),
              wrapWithModel(
                model: _model.subscribtionModel,
                updateCallback: () => safeSetState(() {}),
                child: SubscribtionWidget(),
              ),
            ].divide(SizedBox(height: 20.0)).addToStart(SizedBox(height: 28.0)),
          ),
        ),
      ),
    );
  }
}
