import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jarvis_ai/models/prompt.dart';
import 'package:jarvis_ai/pages/prompt_create._page.dart';
import 'package:jarvis_ai/services/jarvis_service.dart';
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
  final Prompt prompt;
  final Function(bool)? onFavoriteChanged;
  final JarvisService jarvisService;
  final VoidCallback? onEditPressed;
  final VoidCallback? onTap;
  const CardPromtWidget({
    super.key,
    required this.prompt,
    this.onFavoriteChanged,
    required this.jarvisService,
    this.onEditPressed,
    this.onTap
  });

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

  Future<void> _handleFavoriteToggle() async {
    try {
      await widget.jarvisService.toggleFavorite(widget.prompt.id);
      if (widget.onFavoriteChanged != null) {
        widget.onFavoriteChanged!(!widget.prompt.isFavorite!);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to toggle favorite: $e')));
    }
  }

  Future<void> _handleDeletePrompt() async {
    try {
      final user = await widget.jarvisService.getUser();
      if (user != null) {
        if (user.userId != widget.prompt.userId) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You can only delete your own prompt')),
          );
          return;
        }
      } else
        return;
      final result = await widget.jarvisService.deletePrompt(widget.prompt.id);
      if (result == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Delete prompt successfully')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete prompt')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to toggle favorite: $e')));
    }
  }

  void _navigateToPromptDetail() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
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
                    widget.prompt.title,
                    style: JarvisTheme.of(context).titleLarge.override(
                      fontFamily: 'Inter Tight',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                  child: Text(
                    widget.prompt.description ?? '',
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
                          _formatDate(widget.prompt.createdAt),
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
                      onPressed: widget.onEditPressed,
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
                        onPressed: _handleDeletePrompt,
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
                              widget.prompt.isFavorite!
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  widget.prompt.isFavorite!
                                      ? Colors.red
                                      : Colors.white,
                              size: 20.0,
                            ),
                            onPressed: _handleFavoriteToggle,
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
    );
  }
}

String _formatDate(dynamic createdAt) {
  try {
    DateTime date;

    // Handle different createdAt types
    if (createdAt is String) {
      date = DateTime.parse(createdAt);
    } else if (createdAt is DateTime) {
      date = createdAt;
    } else if (createdAt is int) {
      date = DateTime.fromMillisecondsSinceEpoch(createdAt);
    } else {
      return 'Unknown date';
    }

    return DateFormat('MMM d • hh:mm a').format(date);
  } catch (e) {
    return 'Invalid date';
  }
}
