import 'package:clean_kanban/clean_kanban.dart';
import 'package:flutter/material.dart';

import '../../domain/repositories/toggl_repository.dart';

/// Constants for KanbanColumn layout measurements
class KanbanColumnLayout {
  /// Height of the column header
  static const double headerHeight = 64.0;

  /// Padding within the header
  static const double headerPadding = 16.0;

  /// Border radius for the column
  static const double columnBorderRadius = 8.0;

  /// Size of header action buttons
  static const double actionButtonSize = 32.0;

  /// Size of icons within header action buttons
  static const double actionIconSize = 20.0;

  /// Default maximum height for mobile view
  static const double defaultMobileMaxHeight = 400.0;

  /// Width threshold to determine if screen is narrow
  static const double narrowScreenThreshold = 600.0;
}

/// Theme configuration for a Kanban column.
///
/// Defines the visual appearance of a column including colors for various
/// components like background, borders, headers, and action buttons.
class KanbanColumnTheme {
  /// Background color of the column.
  final Color columnBackgroundColor;

  /// Color of the column's border.
  final Color columnBorderColor;

  /// Border width for the column
  final double columnBorderWidth;

  /// Background color of the column header.
  final Color columnHeaderColor;

  /// Text color for the column header.
  final Color columnHeaderTextColor;

  /// Background color for the add task button.
  final Color columnAddButtonBoxColor;

  /// Color of the add task icon.
  final Color columnAddIconColor;

  /// Creates a [KanbanColumnTheme] with customizable colors.
  ///
  /// All parameters have default values that create a standard light theme.
  const KanbanColumnTheme({
    this.columnBackgroundColor = Colors.white,
    this.columnBorderColor = const Color(0xFFE0E0E0),
    this.columnBorderWidth = 0.0,
    this.columnHeaderColor = Colors.blue,
    this.columnHeaderTextColor = Colors.black87,
    this.columnAddButtonBoxColor = const Color.fromARGB(255, 76, 127, 175),
    this.columnAddIconColor = Colors.white,
  });

  /// Creates a copy of this [KanbanColumnTheme] with modified values.
  ///
  /// Any parameter that is null will keep its original value.
  KanbanColumnTheme copyWith({
    Color? columnBackgroundColor,
    Color? columnBorderColor,
    double? columnBorderWidth,
    Color? columnHeaderColor,
    Color? columnHeaderTextColor,
    Color? columnAddButtonBoxColor,
    Color? columnAddIconColor,
  }) {
    return KanbanColumnTheme(
      columnBackgroundColor: columnBackgroundColor ?? this.columnBackgroundColor,
      columnBorderColor: columnBorderColor ?? this.columnBorderColor,
      columnBorderWidth: columnBorderWidth ?? this.columnBorderWidth,
      columnHeaderColor: columnHeaderColor ?? this.columnHeaderColor,
      columnHeaderTextColor: columnHeaderTextColor ?? this.columnHeaderTextColor,
      columnAddButtonBoxColor: columnAddButtonBoxColor ?? this.columnAddButtonBoxColor,
      columnAddIconColor: columnAddIconColor ?? this.columnAddIconColor,
    );
  }
}

/// A widget that displays the header of a Kanban column.
class ColumnHeader extends StatelessWidget {
  /// The column data
  final KanbanColumn column;

  /// Theme configuration for the column
  final KanbanColumnTheme theme;

  /// Callback when the add task button is pressed
  final VoidCallback? onAddTask;

  /// Callback when the clear all done tasks button is pressed
  final VoidCallback? onClearDone;

  /// Creates a [ColumnHeader] widget.
  const ColumnHeader({
    super.key,
    required this.column,
    required this.theme,
    this.onAddTask,
    this.onClearDone,
  }) : super();

  /// Gets the appropriate header color based on theme brightness and column settings
  Color _getHeaderColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.light && column.headerBgColorLight != null) {
      return column.headerBgColorLight!.toColor();
    } else if (brightness == Brightness.dark && column.headerBgColorDark != null) {
      return column.headerBgColorDark!.toColor();
    }
    // Fall back to the theme's default color if no custom color is specified
    return theme.columnHeaderColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(KanbanColumnLayout.headerPadding),
      height: KanbanColumnLayout.headerHeight,
      decoration: BoxDecoration(
        color: _getHeaderColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(KanbanColumnLayout.columnBorderRadius)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title and count grouped together
          Row(
            children: [
              Text(
                column.header,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: theme.columnHeaderTextColor,
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  color: theme.columnBackgroundColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  column.columnLimit != null
                      ? '${column.tasks.length}/${column.columnLimit}'
                      : '${column.tasks.length}',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: theme.columnHeaderTextColor,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              if (column.isDoneColumn()) _buildClearButton(context),
              if (column.canAddTask && onAddTask != null) _buildAddButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return Container(
      height: KanbanColumnLayout.actionButtonSize,
      width: KanbanColumnLayout.actionButtonSize,
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: Colors.red[400]?.withValues(
          alpha: column.tasks.isNotEmpty && onClearDone != null ? 1.0 : 0.3,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IconButton(
        icon: const Icon(Icons.clear_all, size: KanbanColumnLayout.actionIconSize),
        padding: EdgeInsets.zero,
        color: Colors.white,
        tooltip: column.tasks.isEmpty ? 'No tasks to clear' : 'Clear all done tasks',
        onPressed: (column.tasks.isNotEmpty && onClearDone != null)
            ? () => ConfirmationDialog.show(
                  context: context,
                  title: 'Clear all done tasks',
                  message: 'Are you sure you want to clear all done tasks? This action cannot be undone.',
                  label: 'Clear',
                  onPressed: () {
                    onClearDone?.call();
                  },
                )
            : null,
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      height: KanbanColumnLayout.actionButtonSize,
      width: KanbanColumnLayout.actionButtonSize,
      decoration: BoxDecoration(
        color: theme.columnAddButtonBoxColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: IconButton(
        icon: const Icon(Icons.add_rounded, size: KanbanColumnLayout.actionIconSize),
        padding: EdgeInsets.zero,
        color: theme.columnAddIconColor,
        onPressed: onAddTask,
      ),
    );
  }
}

/// A widget that displays the list of tasks in a Kanban column with drag-and-drop support.
class ColumnTaskList extends StatelessWidget {
  /// The column containing the tasks
  final KanbanColumn column;

  /// Theme configuration for the column
  final KanbanColumnTheme theme;

  /// Whether the screen is narrow (mobile)
  final bool isNarrowScreen;

  /// Callback when a task is reordered within the column
  final Function(KanbanColumn column, int oldIndex, int newIndex)? onReorderedTask;

  /// Callback when a task is dropped into this column
  final Function(KanbanColumn source, int sourceIndex, KanbanColumn destination, [int? destinationIndex])?
      onTaskDropped;

  /// Callback when a task's delete button is pressed
  final Function(KanbanColumn column, int index)? onDeleteTask;

  /// Callback when a task's edit button is pressed
  final Function(KanbanColumn column, int index, String initialTitle, String initialSubtitle, Project initialProject)?
      onEditTask;

  final Function? runTask;

  /// Creates a [ColumnTaskList] widget.
  const ColumnTaskList({
    super.key,
    required this.column,
    required this.theme,
    this.isNarrowScreen = false,
    this.onReorderedTask,
    this.onTaskDropped,
    this.onDeleteTask,
    this.onEditTask,
    this.runTask,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return DragTarget<TaskDragData>(
      builder: (context, candidateData, rejectedData) {
        return Stack(
          children: [
            ListView.builder(
              itemCount: column.tasks.length,
              itemBuilder: (context, index) {
                final task = column.tasks[index];
                return _buildDragTargetItem(context, task, index);
              },
            ),
            // Show scroll indicator when there are more tasks
            if (isNarrowScreen && column.tasks.length > 4)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.columnHeaderColor.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      onWillAcceptWithDetails: (details) {
        return _shouldAcceptDrop(details.data.sourceColumn, column);
      },
      onAcceptWithDetails: (details) {
        onTaskDropped?.call(details.data.sourceColumn, details.data.sourceIndex, column);
      },
    );
  }

  Widget _buildDragTargetItem(BuildContext context, Task task, int index) {
    return DragTarget<TaskDragData>(
      builder: (context, candidateData, rejectedData) {
        final effectiveTheme = KanbanThemeProvider.of(context);
        return TaskCard(
          data: TaskDragData(
            task: task,
            sourceColumn: column,
            sourceIndex: index,
          ),
          theme: effectiveTheme.cardTheme,
          onDeleteTask: () => ConfirmationDialog.show(
            context: context,
            title: 'Delete Task',
            message: 'Are you sure you want to delete this task? This action cannot be undone.',
            label: 'Delete',
            onPressed: () {
              onDeleteTask?.call(column, index);
            },
          ),
          onEditTask: () => onEditTask?.call(
            column,
            index,
            task.title,
            task.subtitle,
            task.project ??
                Project(
                  id: -1,
                  name: "Bez projektu",
                  isActive: true,
                  color: Colors.black38.colorToHex(),
                ),
          ),
          runTask: runTask,
        );
      },
      onWillAcceptWithDetails: (details) {
        return _shouldAcceptDrop(details.data.sourceColumn, column);
      },
      onAcceptWithDetails: (details) {
        if (details.data.sourceColumn == column && details.data.sourceIndex != index) {
          onReorderedTask?.call(column, details.data.sourceIndex, index);
        } else {
          onTaskDropped?.call(
            details.data.sourceColumn,
            details.data.sourceIndex,
            column,
            index,
          );
        }
      },
    );
  }

  bool _shouldAcceptDrop(KanbanColumn sourceColumn, KanbanColumn targetColumn) {
    if (targetColumn.columnLimit != null && targetColumn.tasks.length >= targetColumn.columnLimit!) {
      return false; // target column limit reached
    } else {
      return true;
    }
  }
}

/// A widget that represents a column in a Kanban board.
///
/// Handles the display of tasks, drag-and-drop operations, and column-specific
/// actions like adding tasks and clearing completed tasks.
class ColumnWidget extends StatelessWidget {
  /// The column data to display.
  final KanbanColumn column;

  /// Theme configuration for the column.
  final KanbanColumnTheme theme;

  /// Callback when the add task button is pressed.
  final Function()? onAddTask;

  /// Callback when a task is reordered within the column.
  final Function(KanbanColumn column, int oldIndex, int newIndex)? onReorderedTask;

  /// Callback when a task is dropped into this column.
  final Function(KanbanColumn source, int sourceIndex, KanbanColumn destination, [int? destinationIndex])?
      onTaskDropped;

  /// Callback when the clear all done tasks button is pressed.
  final Function()? onClearDone;

  /// Callback when a task's delete button is pressed.
  final Function(KanbanColumn column, int index)? onDeleteTask;

  /// Callback when a task's edit button is pressed.
  final Function(KanbanColumn column, int index, String initialTitle, String initialSubtitle, Project initialProject)?
      onEditTask;

  /// Maximum height for the column when displayed on mobile
  /// Only applied when the column is in a vertical layout
  final double? mobileMaxHeight;

  final Function? runTask;

  /// Creates a [ColumnWidget] with the given parameters.
  ///
  /// The [column] and [theme] parameters are required, while all callbacks
  /// are optional.
  const ColumnWidget({
    super.key,
    required this.column,
    required this.theme,
    this.onAddTask,
    this.onReorderedTask,
    this.onTaskDropped,
    this.onDeleteTask,
    this.onEditTask,
    this.onClearDone,
    this.mobileMaxHeight = KanbanColumnLayout.defaultMobileMaxHeight,
    this.runTask,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrowScreen = constraints.maxWidth < KanbanColumnLayout.narrowScreenThreshold;

        return Container(
          constraints: isNarrowScreen && mobileMaxHeight != null ? BoxConstraints(maxHeight: mobileMaxHeight!) : null,
          decoration: BoxDecoration(
            color: theme.columnBackgroundColor,
            borderRadius: BorderRadius.circular(KanbanColumnLayout.columnBorderRadius),
            border: Border.all(
              color: theme.columnBorderColor,
              width: theme.columnBorderWidth,
            ),
          ),
          child: Column(
            children: [
              ColumnHeader(
                column: column,
                theme: theme,
                onAddTask: onAddTask,
                onClearDone: onClearDone,
              ),
              Expanded(
                child: ColumnTaskList(
                  column: column,
                  theme: theme,
                  isNarrowScreen: isNarrowScreen,
                  onReorderedTask: onReorderedTask,
                  onTaskDropped: onTaskDropped,
                  onDeleteTask: onDeleteTask,
                  onEditTask: onEditTask,
                  runTask: runTask,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
