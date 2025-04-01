import 'package:clean_kanban/clean_kanban.dart';
import 'package:flutter/material.dart';
import './task_drag_data.dart';
import './confirmation_dialog.dart';

/// Theme configuration for a Kanban column.
///
/// Defines the visual appearance of a column including colors for various
/// components like background, borders, headers, and action buttons.
class KanbanColumnTheme {
  /// Background color of the column.
  final Color columnBackgroundColor;

  /// Color of the column's border.
  final Color columnBorderColor;

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
    this.columnHeaderColor = Colors.blue,
    this.columnHeaderTextColor = Colors.black87,
    this.columnAddButtonBoxColor = const Color.fromARGB(255, 76, 127, 175),
    this.columnAddIconColor = Colors.white,
  });
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
  final Function(KanbanColumn column, int oldIndex, int newIndex)?
      onReorderedTask;

  /// Callback when a task is dropped into this column.
  final Function(KanbanColumn source, int sourceIndex, KanbanColumn destination,
      [int? destinationIndex])? onTaskDropped;

  /// Callback when the clear all done tasks button is pressed.
  final Function()? onClearDone;

  /// Callback when a task's delete button is pressed.
  final Function(KanbanColumn column, int index)? onDeleteTask;

  /// Callback when a task's edit button is pressed.
  final Function(KanbanColumn column, int index, String initialTitle, String initialSubtitle)? onEditTask;

  /// Creates a [ColumnWidget] with the given parameters.
  ///
  /// The [column] and [theme] parameters are required, while all callbacks
  /// are optional.
  const ColumnWidget({
    Key? key,
    required this.column,
    required this.theme,
    this.onAddTask,
    this.onReorderedTask,
    this.onTaskDropped,
    this.onDeleteTask,
    this.onEditTask,
    this.onClearDone,
  }) : super(key: key);

  bool _shouldAcceptDrop(KanbanColumn sourceColumn, KanbanColumn targetColumn, bool acceptReorder) {
    if (sourceColumn == targetColumn) {
      return acceptReorder; // reorder task in _buildDragTargetItem
    }
    if (sourceColumn != targetColumn) {
      // check if target column limit not reached
      if (targetColumn.columnLimit != null && targetColumn.tasks.length >= targetColumn.columnLimit!) {
        return false; // target column limit reached
      }
      return true; // this is different column, so we will accept it
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: theme.columnBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: theme.columnBorderColor.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: DragTarget<TaskDragData>(builder: (context, candidateData, rejectedData) { 
              return ListView.builder(
                  itemCount: column.tasks.length,
                  itemBuilder: (context, index) {
                    final task = column.tasks[index];
                    return _buildDragTargetItem(task, index);
                  },
                ); 
              }, onWillAcceptWithDetails: (details) {
                return _shouldAcceptDrop(details.data.sourceColumn, column, false);
              }, onAcceptWithDetails: (details) {
                onTaskDropped?.call(details.data.sourceColumn, details.data.sourceIndex, column);
              })
            ),
          ],
        ));
  }

  Widget _buildDragTargetItem(Task task, int index) {
    return DragTarget<TaskDragData>(builder: (context, candidateData, rejectedData) {
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
          onEditTask: () => onEditTask?.call(column, index, task.title, task.subtitle),
          );
    }, onWillAcceptWithDetails: (details) {
      return _shouldAcceptDrop(details.data.sourceColumn, column, true);
    }, onAcceptWithDetails: (details) {
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
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 64.0,
      decoration: BoxDecoration(
        color: theme.columnHeaderColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
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
              if (column.isDoneColumn())
                Container(
                  height: 32.0,
                  width: 32.0,
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.red[400]?.withValues(alpha: 
                      column.tasks.isNotEmpty && onClearDone != null ? 1.0 : 0.3,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.clear_all, size: 20.0),
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    tooltip: column.tasks.isEmpty
                        ? 'No tasks to clear'
                        : 'Clear all done tasks',
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
                ),
              if (column.canAddTask && onAddTask != null)
                Container(
                  height: 32.0,
                  width: 32.0,
                  decoration: BoxDecoration(
                    color: theme.columnAddButtonBoxColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add_rounded, size: 20.0),
                    padding: EdgeInsets.zero,
                    color: theme.columnAddIconColor,
                    onPressed: onAddTask != null
                        ? () {
                            onAddTask!();
                          }
                        : null,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
