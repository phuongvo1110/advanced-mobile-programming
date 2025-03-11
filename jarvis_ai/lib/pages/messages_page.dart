import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});
  @override
  State<MessagesPage> createState() => _MessagesPageWidgetState();
}

class _MessagesPageWidgetState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JarvisTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: JarvisTheme.of(context).secondary,
        automaticallyImplyLeading: false,
        leading: JarvisIconButton(
          borderRadius: 8,
          buttonSize: 40,
          fillColor: JarvisTheme.of(context).secondary,
          icon: Icon(
            Icons.arrow_back,
            color: JarvisTheme.of(context).info,
            size: 24,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        title: Text(
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
        elevation: 0,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: JarvisTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: JarvisTheme.of(context).accent1,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: JarvisTheme.of(context).primary,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      'https://source.unsplash.com/random/1280x720?user&2',
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    8,
                                    0,
                                    0,
                                    0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Randy Mcdonald',
                                        textAlign: TextAlign.start,
                                        style: JarvisTheme.of(
                                          context,
                                        ).bodyLarge.copyWith(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          4,
                                          0,
                                          0,
                                        ),
                                        child: Text(
                                          'This was really great, i\'m so glad that we could  catchup this weekend.',
                                          textAlign: TextAlign.start,
                                          style: JarvisTheme.of(
                                            context,
                                          ).labelMedium.copyWith(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  0,
                                                  4,
                                                  0,
                                                  0,
                                                ),
                                            child: Text(
                                              'Mon. July 3rd - 4:12pm',
                                              textAlign: TextAlign.start,
                                              style: JarvisTheme.of(
                                                context,
                                              ).labelSmall.copyWith(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color:
                                                JarvisTheme.of(
                                                  context,
                                                ).secondaryText,
                                            size: 24,
                                          ),
                                        ],
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
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: JarvisTheme.of(context).alternate,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: JarvisTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: JarvisTheme.of(context).accent1,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: JarvisTheme.of(context).primary,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      'https://source.unsplash.com/random/1280x720?user&2',
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    8,
                                    0,
                                    0,
                                    0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Randy Mcdonald',
                                        textAlign: TextAlign.start,
                                        style: JarvisTheme.of(
                                          context,
                                        ).bodyLarge.copyWith(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          4,
                                          0,
                                          0,
                                        ),
                                        child: Text(
                                          'This was really great, i\'m so glad that we could  catchup this weekend.',
                                          textAlign: TextAlign.start,
                                          style: JarvisTheme.of(
                                            context,
                                          ).labelMedium.copyWith(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  0,
                                                  4,
                                                  0,
                                                  0,
                                                ),
                                            child: Text(
                                              'Mon. July 3rd - 4:12pm',
                                              textAlign: TextAlign.start,
                                              style: JarvisTheme.of(
                                                context,
                                              ).labelSmall.copyWith(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color:
                                                JarvisTheme.of(
                                                  context,
                                                ).secondaryText,
                                            size: 24,
                                          ),
                                        ],
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
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: JarvisTheme.of(context).alternate,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: JarvisTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: JarvisTheme.of(context).accent1,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: JarvisTheme.of(context).primary,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      'https://source.unsplash.com/random/1280x720?user&2',
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    8,
                                    0,
                                    0,
                                    0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Randy Mcdonald',
                                        textAlign: TextAlign.start,
                                        style: JarvisTheme.of(
                                          context,
                                        ).bodyLarge.copyWith(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          4,
                                          0,
                                          0,
                                        ),
                                        child: Text(
                                          'This was really great, i\'m so glad that we could  catchup this weekend.',
                                          textAlign: TextAlign.start,
                                          style: JarvisTheme.of(
                                            context,
                                          ).labelMedium.copyWith(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  0,
                                                  4,
                                                  0,
                                                  0,
                                                ),
                                            child: Text(
                                              'Mon. July 3rd - 4:12pm',
                                              textAlign: TextAlign.start,
                                              style: JarvisTheme.of(
                                                context,
                                              ).labelSmall.copyWith(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color:
                                                JarvisTheme.of(
                                                  context,
                                                ).secondaryText,
                                            size: 24,
                                          ),
                                        ],
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
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: JarvisTheme.of(context).alternate,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: JarvisTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: JarvisTheme.of(context).accent1,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: JarvisTheme.of(context).primary,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      'https://source.unsplash.com/random/1280x720?user&2',
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    8,
                                    0,
                                    0,
                                    0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Randy Mcdonald',
                                        textAlign: TextAlign.start,
                                        style: JarvisTheme.of(
                                          context,
                                        ).bodyLarge.copyWith(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          4,
                                          0,
                                          0,
                                        ),
                                        child: Text(
                                          'This was really great, i\'m so glad that we could  catchup this weekend.',
                                          textAlign: TextAlign.start,
                                          style: JarvisTheme.of(
                                            context,
                                          ).labelMedium.copyWith(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  0,
                                                  4,
                                                  0,
                                                  0,
                                                ),
                                            child: Text(
                                              'Mon. July 3rd - 4:12pm',
                                              textAlign: TextAlign.start,
                                              style: JarvisTheme.of(
                                                context,
                                              ).labelSmall.copyWith(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color:
                                                JarvisTheme.of(
                                                  context,
                                                ).secondaryText,
                                            size: 24,
                                          ),
                                        ],
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
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: JarvisTheme.of(context).alternate,
            ),
          ],
        ),
      ),
    );
  }
}
