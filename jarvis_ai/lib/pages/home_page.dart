import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:jarvis_ai/models/assistant.dart';
import 'package:jarvis_ai/models/member.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.apiStore});
  final ApiStore apiStore;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  bool _isInterstitialAdReady = false;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollPageController = ScrollController();

  Member? member;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _initBannerAd();
    _initInterstitialAd();
    _loadMemberData();
    _loadAssistants(refresh: true);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.apiStore.kbService.loadMoreAssistants();
    }
  }

  Future<void> _loadAssistants({bool refresh = false}) async {
    try {
      await widget.apiStore.kbService.getAssistants(
        limit: 3,
        refresh: refresh,
        isFavorite: false,
        isPublished: false,
        order: 'ASC',
        order_field: 'createdAt',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load AI Bots: ${e.toString()}')),
      );
    }
  }

  Future<void> _loadMemberData() async {
    try {
      final member = await widget.apiStore.jarvisService.getCurrentUser();
      if (member != null && mounted) {
        setState(() {
          this.member = member;
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

  void _initBannerAd() {
    _bannerAd = BannerAd(
      adUnitId:
          'ca-app-pub-7659303740648994/9683215606',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Banner ad failed to load: $error');
        },
      ),
    )..load();
  }

  void _initInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-7659303740648994/9116255309',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
          });
          _interstitialAd!
              .fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              setState(() {
                _isInterstitialAdReady = false;
              });
              _initInterstitialAd(); // Load a new ad after the previous one is dismissed
            },
            onAdFailedToShowFullScreenContent: (
              InterstitialAd ad,
              AdError error,
            ) {
              ad.dispose();
              print('Interstitial ad failed to show: $error');
              setState(() {
                _isInterstitialAdReady = false;
              });
              _initInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
          setState(() {
            _isInterstitialAdReady = false;
          });
        },
      ),
    );
  }

  void _showInterstitialAd(String route) async {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.show().then((_) async {
        print('Interstitial ad shown successfully');
        // Navigate after the ad is shown or dismissed
        final result = await Navigator.pushNamed(context, route);
        if (result != null && result == true) {
          _loadAssistants(refresh: true);
        }
      });
    } else {
      // If ad isn't ready, navigate directly
      final result = await Navigator.pushNamed(context, route);
        if (result != null && result == true) {
          _loadAssistants(refresh: true);
        }
      _initInterstitialAd(); // Try loading a new ad
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String usernameInitial =
        member?.username?.isNotEmpty == true ? member!.username![0] : 'G';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: JarvisTheme.of(context).secondary,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
        Image.asset(
          'assets/ai-logo.png',
          width: 40,
          height: 40,
        ),
        SizedBox(width: 8),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          child: Text(
            'Jarvis.AI',
            style: JarvisTheme.of(context).displaySmall.copyWith(
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
        ),
          ],
        ),
        actions: [
          Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
        child: JarvisIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
          color: Color(
            (Random().nextDouble() * 0xFFFFFF).toInt(),
          ).withOpacity(1.0),
          shape: BoxShape.circle,
            ),
            child: Center(
          child: Text(
            usernameInitial,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
            ),
          ),
          onPressed: () async {
            Navigator.pushNamed(context, '/profile');
          },
        ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
              child: SingleChildScrollView(
                primary: false,
                controller: _scrollPageController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      color: Colors.transparent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5FBFB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            20,
                            20,
                            20,
                            20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Quick Actions',
                                style: JarvisTheme.of(
                                  context,
                                ).headlineSmall.copyWith(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF101518),
                                  fontSize: 24,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 16),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                direction: Axis.horizontal,
                                runAlignment: WrapAlignment.start,
                                verticalDirection: VerticalDirection.down,
                                clipBehavior: Clip.none,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _showInterstitialAd('/chat');
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                16,
                                                16,
                                                16,
                                                16,
                                              ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.chat_bubble_outline,
                                                color: Color(0xFF06D5CD),
                                                size: 32,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'New Chat',
                                                style: JarvisTheme.of(
                                                  context,
                                                ).bodyMedium.copyWith(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFF101518),
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showInterstitialAd('/data');
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                16,
                                                16,
                                                16,
                                                16,
                                              ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.storage,
                                                color: Color(0xFF06D5CD),
                                                size: 32,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Data',
                                                style: JarvisTheme.of(
                                                  context,
                                                ).bodyMedium.copyWith(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFF101518),
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final result = await Navigator.pushNamed(
                                        context,
                                        '/bots',
                                      );
                                      if (result != null && result == true) {
                                        _loadAssistants(refresh: true);
                                      }
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                16,
                                                16,
                                                16,
                                                16,
                                              ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.smart_toy,
                                                color: Color(0xFF06D5CD),
                                                size: 32,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Bots',
                                                style: JarvisTheme.of(
                                                  context,
                                                ).bodyMedium.copyWith(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFF101518),
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showInterstitialAd('/email');
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                16,
                                                16,
                                                16,
                                                16,
                                              ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.mail,
                                                color: Color(0xFF06D5CD),
                                                size: 32,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Email',
                                                style: JarvisTheme.of(
                                                  context,
                                                ).bodyMedium.copyWith(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFF101518),
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
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
                    ),
                    SizedBox(height: 24),
                    Material(
                      color: Colors.transparent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5FBFB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            20,
                            20,
                            20,
                            20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Chat with bots',
                                style: JarvisTheme.of(
                                  context,
                                ).headlineSmall.copyWith(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF101518),
                                  fontSize: 24,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Expanded(
                                    child: RefreshIndicator(
                                      onRefresh:
                                          () => _loadAssistants(refresh: true),
                                      child: Observer(
                                        builder: (context) {
                                          final assistants =
                                              widget
                                                  .apiStore
                                                  .kbService
                                                  .assistants
                                                  .toList();
                                          if (widget
                                              .apiStore
                                              .kbService
                                              .isLoading) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          if (assistants.isEmpty &&
                                              !widget
                                                  .apiStore
                                                  .kbService
                                                  .isLoading) {
                                            return Center(
                                              child: Text(
                                                'No AI Bots available.',
                                                style: JarvisTheme.of(
                                                  context,
                                                ).bodyMedium.copyWith(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFF101518),
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            );
                                          }
                                          return ListView.builder(
                                            controller: _scrollController,
                                            shrinkWrap: true,
                                            itemCount:
                                                widget
                                                    .apiStore
                                                    .kbService
                                                    .assistants
                                                    .length,
                                            itemBuilder: (context, index) {
                                              if (index >=
                                                  widget
                                                      .apiStore
                                                      .kbService
                                                      .assistants
                                                      .length) {
                                                return widget
                                                        .apiStore
                                                        .kbService
                                                        .isLoading
                                                    ? Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                    : SizedBox.shrink();
                                              }
                                              final assistant =
                                                  widget
                                                      .apiStore
                                                      .kbService
                                                      .assistants[index];
                                              return GestureDetector(
                                                onTap: () async {
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/chat',
                                                    arguments: {
                                                      'assistantId':
                                                          assistant.id,
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        16,
                                                        0,
                                                        16,
                                                        8,
                                                      ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  0,
                                                                ),
                                                            bottomRight:
                                                                Radius.circular(
                                                                  0,
                                                                ),
                                                            topLeft:
                                                                Radius.circular(
                                                                  12,
                                                                ),
                                                            topRight:
                                                                Radius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        12,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                assistant
                                                                        .assistantName ??
                                                                    'Unknown',
                                                                style: JarvisTheme.of(
                                                                  context,
                                                                ).bodyLarge.copyWith(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Color(
                                                                    0xFF101518,
                                                                  ),
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              Text(
                                                                assistant
                                                                        .description ??
                                                                    'No description available',
                                                                style: JarvisTheme.of(
                                                                  context,
                                                                ).bodyMedium.copyWith(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Color(
                                                                    0xFF57636C,
                                                                  ),
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            assistant.updatedAt !=
                                                                    null
                                                                ? DateFormat(
                                                                  'dd/MM/yyyy',
                                                                ).format(
                                                                  DateTime.parse(
                                                                    assistant
                                                                        .updatedAt!,
                                                                  ),
                                                                )
                                                                : 'N/A',
                                                            style: JarvisTheme.of(
                                                              context,
                                                            ).bodySmall.copyWith(
                                                              fontFamily:
                                                                  'Inter',
                                                              color: Color(
                                                                0xFF57636C,
                                                              ),
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                                      ],
                ),
              ),
            ),
          ),
          if (_isAdLoaded && _bannerAd != null)
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}

class BotCardWidget extends StatelessWidget {
  final AssistantDetail assistant;
  final Function onTap;
  const BotCardWidget({Key? key, required this.assistant, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = JarvisTheme.of(context);
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Shrink-wrap the row
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.alternate, width: 1),
                ),
                child: const Center(
                  child: Icon(
                    Icons.smart_toy_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),

              // Title & subtitle
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assistant.assistantName ?? 'Assistant',
                        style: theme.titleMedium.override(
                          fontFamily: 'Inter Tight',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        assistant.description ?? '',
                        style: theme.bodySmall.override(
                          fontFamily: 'Inter',
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
