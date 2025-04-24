import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jarvis_ai/models/conversation.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key, required this.apiStore});
  final ApiStore apiStore;
  @override
  State<MessagesPage> createState() => _MessagesPageWidgetState();
}

class _MessagesPageWidgetState extends State<MessagesPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations({bool refresh = false}) async {
    try {
      await widget.apiStore.jarvisService.getConversations(refresh: refresh);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load conversations: ${e.toString()}'),
        ),
      );
    }
  }

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
            Expanded(
              child: RefreshIndicator(
                child: Observer(
                  builder: (context) {
                    final conversations =
                        widget.apiStore.jarvisService.conversations.toList();
                    final isLoading = widget.apiStore.jarvisService.isLoading;
                    if (isLoading && conversations.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (conversations.isEmpty) {
                      return Center(
                        child: Text(
                          'No conversations yet',
                          style: JarvisTheme.of(context).bodyMedium,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = conversations[index];
                        return _ConversationItem(
                          conversation: conversation,
                          onTap: () {
                            // Navigate to conversation detail
                            // Navigator.push(context, MaterialPageRoute(
                            //   builder: (context) => ConversationDetailPage(
                            //     conversation: conversation,
                            //   ),
                            // ));
                          },
                        );
                      },
                    );
                  },
                ),
                onRefresh: () async {
                  await _loadConversations(refresh: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationItem extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const _ConversationItem({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: JarvisTheme.of(context).secondaryBackground,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
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
                    padding: const EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        'https://source.unsplash.com/random/1280x720?ai&${conversation.id}',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conversation.title ?? 'New Conversation',
                          style: JarvisTheme.of(context).bodyLarge.copyWith(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                        ),
                        // if (conversation.lastMessage != null)
                        //   Padding(
                        //     padding: const EdgeInsetsDirectional.fromSTEB(
                        //       0,
                        //       4,
                        //       0,
                        //       0,
                        //     ),
                        //     child: Text(
                        //       conversation.lastMessage!,
                        //       maxLines: 1,
                        //       overflow: TextOverflow.ellipsis,
                        //       style: JarvisTheme.of(
                        //         context,
                        //       ).labelMedium.copyWith(
                        //         fontFamily: 'Inter',
                        //         letterSpacing: 0.0,
                        //       ),
                        //     ),
                        //   ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                0,
                                4,
                                0,
                                0,
                              ),
                              child: Text(
                                _formatDate(conversation.createdAt),
                                style: JarvisTheme.of(
                                  context,
                                ).labelSmall.copyWith(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, size: 24),
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
    );
  }

  String _formatDate(dynamic dateTimeInput) {
    try {
      DateTime date;

      // Handle different input types
      if (dateTimeInput is String) {
        date = DateTime.parse(dateTimeInput);
      } else if (dateTimeInput is DateTime) {
        date = dateTimeInput;
      } else if (dateTimeInput is int) {
        // Assuming milliseconds since epoch if it's an int
        date = DateTime.fromMillisecondsSinceEpoch(dateTimeInput);
      } else {
        return '';
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final dateOnly = DateTime(date.year, date.month, date.day);

      // Determine day prefix
      String dayPrefix;
      if (dateOnly == today) {
        dayPrefix = 'Today';
      } else if (dateOnly == yesterday) {
        dayPrefix = 'Yesterday';
      } else {
        dayPrefix = '${_getMonthName(date.month)} ${date.day}';
        if (date.year != now.year) {
          dayPrefix += ', ${date.year}';
        }
      }

      // Format time
      final hour = date.hour % 12;
      final period = date.hour < 12 ? 'AM' : 'PM';
      final minute = date.minute.toString().padLeft(2, '0');

      return '$dayPrefix - ${hour == 0 ? 12 : hour}:$minute $period';
    } catch (e) {
      debugPrint('Error formatting date: $e');
      return '';
    }
  }

  String _getMonthName(int month) {
    return const [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][month - 1];
  }
}
