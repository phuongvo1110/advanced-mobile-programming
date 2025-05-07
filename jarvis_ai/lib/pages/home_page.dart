import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.apiStore});
  final ApiStore apiStore;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: JarvisTheme.of(context).secondary,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(55, 0, 0, 0),
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
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
            child: JarvisIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              borderWidth: 1,
              buttonSize: 60,
              icon: FaIcon(
                FontAwesomeIcons.solidCircleUser,
                color: JarvisTheme.of(context).primaryText,
                size: 30,
              ),
              onPressed: () async {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
        child: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Quick Actions',
                          style: JarvisTheme.of(context).headlineSmall.copyWith(
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
                                Navigator.pushNamed(context, '/chat');
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
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
                                Navigator.pushNamed(context, '/data');
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
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
                              onTap: () {
                                Navigator.pushNamed(context, '/bots');
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
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
                                Navigator.pushNamed(context, '/email');
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
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
                                          Icons.text_fields,
                                          color: Color(0xFF06D5CD),
                                          size: 32,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Prompts',
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
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Recent Conversations',
                          style: JarvisTheme.of(context).headlineSmall.copyWith(
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
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    16,
                                    0,
                                    16,
                                    0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(0),
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Travel Planning',
                                                style: JarvisTheme.of(
                                                  context,
                                                ).bodyLarge.copyWith(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFF101518),
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                'Help me plan my trip to Japan',
                                                style: JarvisTheme.of(
                                                  context,
                                                ).bodyMedium.copyWith(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFF57636C),
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '2m ago',
                                            style: JarvisTheme.of(
                                              context,
                                            ).bodySmall.copyWith(
                                              fontFamily: 'Inter',
                                              color: Color(0xFF57636C),
                                              fontSize: 12,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    16,
                                    0,
                                    16,
                                    0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Recipe Ideas',
                                                style: JarvisTheme.of(
                                                  context,
                                                ).bodyLarge.copyWith(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFF101518),
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                'Suggest healthy dinner recipes',
                                                style: JarvisTheme.of(
                                                  context,
                                                ).bodyMedium.copyWith(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFF57636C),
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '1h ago',
                                            style: JarvisTheme.of(
                                              context,
                                            ).bodySmall.copyWith(
                                              fontFamily: 'Inter',
                                              color: Color(0xFF57636C),
                                              fontSize: 12,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    16,
                                    0,
                                    16,
                                    0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Coding Help',
                                                style: JarvisTheme.of(
                                                  context,
                                                ).bodyLarge.copyWith(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFF101518),
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                'Debug my Python script',
                                                style: JarvisTheme.of(
                                                  context,
                                                ).bodyMedium.copyWith(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFF57636C),
                                                  fontSize: 14,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '3h ago',
                                            style: JarvisTheme.of(
                                              context,
                                            ).bodySmall.copyWith(
                                              fontFamily: 'Inter',
                                              color: Color(0xFF57636C),
                                              fontSize: 12,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Suggested Topics',
                          style: JarvisTheme.of(context).headlineSmall.copyWith(
                            fontFamily: 'Readex Pro',
                            color: Color(0xFF101518),
                            fontSize: 24,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          direction: Axis.horizontal,
                          runAlignment: WrapAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  8,
                                  16,
                                  8,
                                  16,
                                ),
                                child: Text(
                                  'Writing Assistant',
                                  style: JarvisTheme.of(
                                    context,
                                  ).bodyMedium.copyWith(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF1565C0),
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  8,
                                  16,
                                  8,
                                  16,
                                ),
                                child: Text(
                                  'Math Help',
                                  style: JarvisTheme.of(
                                    context,
                                  ).bodyMedium.copyWith(
                                    fontFamily: 'Inter',
                                    color: Color(0xFFEF6C00),
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  8,
                                  16,
                                  8,
                                  16,
                                ),
                                child: Text(
                                  'Language Learning',
                                  style: JarvisTheme.of(
                                    context,
                                  ).bodyMedium.copyWith(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF2E7D32),
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFFCE4EC),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  8,
                                  16,
                                  8,
                                  16,
                                ),
                                child: Text(
                                  'Creative Ideas',
                                  style: JarvisTheme.of(
                                    context,
                                  ).bodyMedium.copyWith(
                                    fontFamily: 'Inter',
                                    color: Color(0xFFC2185B),
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
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
            ],
          ),
        ),
      ),
    );
  }
}
