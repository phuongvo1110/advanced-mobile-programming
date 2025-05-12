import 'package:jarvis_ai/models/user_token.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/flutter_flow_util.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '/components/subscribtion_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class SubscribtionModel extends FlutterFlowModel<SubscribtionWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

class AISubscribtionPageModel extends FlutterFlowModel<AISubscribtionPageWidget> {
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
  const AISubscribtionPageWidget({super.key, required this.apiStore});
  final ApiStore apiStore;

  @override
  State<AISubscribtionPageWidget> createState() => _AISubscribtionPageWidgetState();
}

class _AISubscribtionPageWidgetState extends State<AISubscribtionPageWidget> {
  late AISubscribtionPageModel _model;
  UserToken? subscriptionData;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AISubscribtionPageModel());
    _fetchSubscription();
  }

  Future<void> _fetchSubscription() async {
    try {
      subscriptionData = await widget.apiStore.jarvisService.getUserToken();
      setState(() {});
    } catch (e) {
      print('Error fetching subscription data: $e');
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = JarvisTheme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondary,
        automaticallyImplyLeading: false,
        leading: JarvisIconButton(
          borderRadius: 8.0,
          buttonSize: 40.0,
          fillColor: theme.secondary,
          icon: Icon(Icons.arrow_back, color: theme.info, size: 24.0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'My Subscription',
          style: theme.displaySmall.override(
            fontFamily: 'Poppins',
            color: theme.primaryText,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: theme.secondaryText,
                offset: const Offset(2.0, 2.0),
                blurRadius: 2.0,
              ),
            ],
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchSubscription,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.apiStore.jarvisService.isUserTokenLoading)
                  const Center(child: CircularProgressIndicator())
                else if (subscriptionData != null)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.alternate, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subscription Plan',
                                style: theme.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  subscriptionData!.name.toString().toUpperCase(),
                                  style: theme.bodyMedium.copyWith(
                                    color: theme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTokenRow(
                            theme,
                            'Daily Tokens',
                            subscriptionData!.dailyTokens.toString(),
                          ),
                          const SizedBox(height: 8),
                          _buildTokenRow(
                            theme,
                            'Monthly Tokens',
                            subscriptionData!.monthlyTokens.toString(),
                          ),
                          const SizedBox(height: 8),
                          _buildTokenRow(
                            theme,
                            'Annually Tokens',
                            subscriptionData!.annuallyTokens.toString(),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Center(
                    child: Text(
                      'No subscription data available',
                      style: theme.bodyMedium,
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    const subscriptionUrl = 'https://dev.jarvis.cx/pricing?source=web_subscription_jarvis_pro';
                    await launchUrl(Uri.parse(subscriptionUrl));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.secondary,
                    foregroundColor: theme.info,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Jarvis Pro',
                    style: theme.titleSmall.override(
                      fontFamily: 'Inter Tight',
                      color: theme.info,
                      letterSpacing: 0.0,
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

  Widget _buildTokenRow(dynamic theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.bodyMedium.copyWith(color: theme.secondaryText),
        ),
        Text(
          value,
          style: theme.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryText,
          ),
        ),
      ],
    );
  }
}