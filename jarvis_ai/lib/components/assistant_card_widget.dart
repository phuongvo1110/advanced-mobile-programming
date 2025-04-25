import 'package:flutter/material.dart';
import 'package:jarvis_ai/models/assistant.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

class AssistantCardWidget extends StatelessWidget {
  final AssistantDetail assistant;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final ApiStore apiStore;

  const AssistantCardWidget({
    required this.assistant,
    this.onEditPressed,
    this.onDeletePressed,
    super.key,
    required this.apiStore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = JarvisTheme.of(context);
    final menuController = MenuController(); // Controller for MenuAnchor

    return GestureDetector(
      onTap: () async {
        Navigator.pushNamed(
          context,
          '/chat',
          arguments: {'assistantId': assistant.id},
        );
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
        child: Container(
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
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
                          assistant.assistantName,
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

                // MenuAnchor with Edit and Delete options
                MenuAnchor(
                  controller: menuController,
                  menuChildren: [
                    MenuItemButton(
                      leadingIcon: Icon(
                        Icons.edit,
                        color: theme.primaryText,
                        size: 20,
                      ),
                      onPressed: onEditPressed,
                      child: Text(
                        'Edit',
                        style: theme.bodyMedium.override(
                          fontFamily: 'Inter',
                          color: theme.primaryText,
                        ),
                      ),
                    ),
                    MenuItemButton(
                      leadingIcon: Icon(
                        Icons.delete,
                        color: theme.error,
                        size: 20,
                      ),
                      onPressed: onDeletePressed,
                      child: Text(
                        'Delete',
                        style: theme.bodyMedium.override(
                          fontFamily: 'Inter',
                          color: theme.error,
                        ),
                      ),
                    ),
                  ],
                  child: JarvisIconButton(
                    borderRadius: 20,
                    buttonSize: 40,
                    icon: Icon(
                      Icons.more_vert,
                      color: theme.secondaryText,
                      size: 24,
                    ),
                    onPressed: () {
                      if (menuController.isOpen) {
                        menuController.close();
                      } else {
                        menuController.open();
                      }
                    },
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
