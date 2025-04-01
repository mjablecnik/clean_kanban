import 'package:flutter/material.dart';
import 'task_drag_data.dart';

/// Theme configuration for a task card.
///
/// Defines the visual appearance of a task card including colors for
/// background, borders, text, and interactive elements.
class TaskCardTheme {
  /// Background color of the card.
  final Color cardBackgroundColor;

  /// Color of the card's border.
  final Color cardBorderColor;

  /// Text color for the task title.
  final Color cardTitleColor;

  /// Text color for the task subtitle.
  final Color cardSubtitleColor;

  /// Color for enabled move/drag icons.
  final Color cardMoveIconEnabledColor;

  /// Color for disabled move/drag icons.
  final Color cardMoveIconDisabledColor;

  /// Creates a [TaskCardTheme] with customizable colors.
  ///
  /// All parameters have default values that create a standard light theme.
  const TaskCardTheme({
    this.cardBackgroundColor = Colors.white,
    this.cardBorderColor = const Color(0xFFE0E0E0),
    this.cardTitleColor = const Color.fromRGBO(0, 0, 0, 0.867),
    this.cardSubtitleColor = const Color.fromRGBO(0, 0, 0, 0.541),
    this.cardMoveIconEnabledColor = const Color.fromRGBO(25, 118, 210, 1),
    this.cardMoveIconDisabledColor = const Color.fromRGBO(224, 224, 224, 1),
  });
}

/// A widget that displays a draggable task card.
///
/// This widget represents a single task in the Kanban board and supports
/// drag-and-drop operations, editing, and deletion of tasks.
class TaskCard extends StatelessWidget {
  /// The data associated with this task card, used for drag operations.
  final TaskDragData data;

  /// Theme configuration for the card's appearance.
  final TaskCardTheme theme;

  /// Callback function when the delete button is pressed.
  final VoidCallback? onDeleteTask;

  /// Callback function when the edit button is pressed.
  final VoidCallback? onEditTask;

  /// Creates a [TaskCard] widget.
  ///
  /// The [data] and [theme] parameters are required, while [onDeleteTask]
  /// and [onEditTask] callbacks are optional.
  const TaskCard({
    Key? key,
    required this.data,
    required this.theme,
    this.onDeleteTask,
    this.onEditTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return LongPressDraggable<TaskDragData>(
          delay: const Duration(milliseconds: 120),
          data: data,
          feedback: Material(
            elevation: 8.0,
            child: Container(
              width: constraints.maxWidth,
              constraints: BoxConstraints(
                minWidth: 280.0,
                maxWidth: 600.0, // Maximum width for desktop
              ),
              child: Transform.scale(
                scale: 1.04,
                child: _buildCardContent(isDragging: true),
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: _buildCardContent(isDragging: false),
          ),
          child: _buildCardContent(isDragging: false),
        );
      },
    );
  }

  Widget _buildCardContent({required bool isDragging}) {
    return Card(
      elevation: isDragging ? 0 : 2.0,
      color: theme.cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: theme.cardBorderColor,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: Container(
          decoration: BoxDecoration(
            gradient: isDragging
                ? null
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.cardBackgroundColor,
                      theme.cardBackgroundColor.withValues(alpha: 0.95),
                    ],
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 8.0, 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            data.task.title,
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              color: theme.cardTitleColor,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            data.task.subtitle,
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.3,
                              color: theme.cardSubtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: theme.cardBorderColor.withValues(alpha: 0.7),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildControlButton(
                            icon: Icons.mode_edit_outline,
                            onPressed: onEditTask,
                            tooltip: 'Edit this task',
                            color: theme.cardMoveIconEnabledColor,
                          ),
                          Container(
                            height: 1,
                            width: 16,
                            margin: const EdgeInsets.symmetric(vertical: 2.0),
                            color: theme.cardBorderColor.withValues(alpha: 0.7),
                          ),
                          _buildControlButton(
                            icon: Icons.delete_outline,
                            onPressed: onDeleteTask,
                            tooltip: 'Delete this task',
                            color: theme.cardMoveIconEnabledColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    VoidCallback? onPressed,
    required String tooltip,
    required Color color,
  }) {
    return SizedBox(
      width: 32.0,
      height: 28.0,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 18.0,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
