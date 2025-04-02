import 'package:flutter/material.dart';
import 'task_drag_data.dart';

/// Constants for TaskCard layout measurements
class TaskCardLayout {
  /// Border radius for the task card corners.
  static const double cardBorderRadius = 8.0;
  
  /// Default elevation for the task card.
  static const double cardElevation = 2.0;
  
  /// Elevation applied to the card when it's being dragged.
  static const double cardDraggingElevation = 8.0;
  
  /// Scale factor applied to the card during drag operations.
  static const double dragScale = 1.04;
  
  /// Padding for the main content area of the card.
  static const double contentPadding = 16.0;
  
  /// Padding for the controls section of the card.
  static const double controlsPadding = 8.0;
  
  /// Delay before a long press is recognized as a drag operation.
  static const Duration dragDelay = Duration(milliseconds: 120);
  
  /// Minimum width constraint for the task card.
  static const double minCardWidth = 280.0;
  
  /// Maximum width constraint for the task card.
  static const double maxCardWidth = 600.0;

  // Text styles
  /// Font size used for the task title.
  static const double titleFontSize = 17.0;
  
  /// Font size used for the task subtitle.
  static const double subtitleFontSize = 14.0;
  
  /// Letter spacing for the task title text.
  static const double titleLetterSpacing = -0.3;
  
  /// Line height multiplier for the subtitle text.
  static const double subtitleLineHeight = 1.3;

  // Control buttons
  /// Width of control buttons in the card.
  static const double controlButtonWidth = 32.0;
  
  /// Height of control buttons in the card.
  static const double controlButtonHeight = 28.0;
  
  /// Size of icons used in control buttons.
  static const double controlIconSize = 18.0;
  
  /// Width of the divider between control buttons.
  static const double controlDividerWidth = 16.0;
  
  /// Border radius for control button hit areas.
  static const double controlBorderRadius = 4.0;
}

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

/// A widget that displays the content of a task card.
class TaskCardContent extends StatelessWidget {
  /// The data associated with this task, used to display title and subtitle.
  final TaskDragData data;
  
  /// Theme configuration for styling the content.
  final TaskCardTheme theme;

  /// Creates a [TaskCardContent] widget.
  ///
  /// The [data] parameter provides the task information to display.
  /// The [theme] parameter controls the visual styling of the content.
  const TaskCardContent({
    super.key,
    required this.data,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data.task.title,
          style: TextStyle(
            fontSize: TaskCardLayout.titleFontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: TaskCardLayout.titleLetterSpacing,
            color: theme.cardTitleColor,
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          data.task.subtitle,
          style: TextStyle(
            fontSize: TaskCardLayout.subtitleFontSize,
            height: TaskCardLayout.subtitleLineHeight,
            color: theme.cardSubtitleColor,
          ),
        ),
      ],
    );
  }
}

/// A widget that displays the control buttons for a task card.
class TaskCardControls extends StatelessWidget {
  /// Callback function triggered when the edit button is pressed.
  final VoidCallback? onEditTask;
  
  /// Callback function triggered when the delete button is pressed.
  final VoidCallback? onDeleteTask;
  
  /// Theme configuration for styling the control buttons.
  final TaskCardTheme theme;

  /// Creates a [TaskCardControls] widget.
  ///
  /// The [onEditTask] callback is triggered when the edit button is pressed.
  /// The [onDeleteTask] callback is triggered when the delete button is pressed.
  /// The [theme] parameter controls the visual styling of the controls.
  const TaskCardControls({
    super.key,
    this.onEditTask,
    this.onDeleteTask,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            width: TaskCardLayout.controlDividerWidth,
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
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    VoidCallback? onPressed,
    required String tooltip,
    required Color color,
  }) {
    return SizedBox(
      width: TaskCardLayout.controlButtonWidth,
      height: TaskCardLayout.controlButtonHeight,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(TaskCardLayout.controlBorderRadius),
            child: Container(
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: TaskCardLayout.controlIconSize,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
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
    super.key,
    required this.data,
    required this.theme,
    this.onDeleteTask,
    this.onEditTask,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return LongPressDraggable<TaskDragData>(
          delay: TaskCardLayout.dragDelay,
          data: data,
          feedback: Material(
            elevation: TaskCardLayout.cardDraggingElevation,
            child: Container(
              width: constraints.maxWidth,
              constraints: BoxConstraints(
                minWidth: TaskCardLayout.minCardWidth,
                maxWidth: TaskCardLayout.maxCardWidth,
              ),
              child: Transform.scale(
                scale: TaskCardLayout.dragScale,
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
      elevation: isDragging ? 0 : TaskCardLayout.cardElevation,
      color: theme.cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TaskCardLayout.cardBorderRadius),
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              TaskCardLayout.contentPadding,
              12.0,
              TaskCardLayout.controlsPadding,
              12.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TaskCardContent(
                    data: data,
                    theme: theme,
                  ),
                ),
                const SizedBox(width: 8.0),
                TaskCardControls(
                  onEditTask: onEditTask,
                  onDeleteTask: onDeleteTask,
                  theme: theme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
