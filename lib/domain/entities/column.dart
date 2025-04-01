import 'task.dart';
import 'package:clean_kanban/core/exceptions.dart';

/// Represents a column in a Kanban board that contains tasks.
///
/// Each column has a unique [id], [header], optional [columnLimit],
/// and can be configured to allow or disallow direct task additions.
class KanbanColumn {
  /// Unique identifier for the column.
  final String id;

  /// Display header text for the column.
  final String header;

  /// Maximum number of tasks allowed in this column.
  /// If null, there is no limit.
  final int? columnLimit;

  /// List of tasks currently in this column.
  final List<Task> tasks = [];

  /// Whether tasks can be directly added to this column.
  final bool canAddTask;

  /// Creates a new Kanban column.
  ///
  /// [id] and [header] are required.
  /// [columnLimit] is optional and defaults to null (no limit).
  /// [canAddTask] defaults to true.
  KanbanColumn({
    required this.id,
    required this.header,
    this.columnLimit,
    this.canAddTask = true,
  });

  /// Adds a task to this column.
  ///
  /// Throws [ColumnLimitExceededException] if adding the task would exceed
  /// the column's limit.
  void addTask(Task task) {
    // Ensure column limit is obeyed when adding a new task.
    if (columnLimit != null && tasks.length >= columnLimit!) {
      throw ColumnLimitExceededException(id);
    }
    tasks.add(task);
  }

  /// Reorders a task within this column.
  ///
  /// Throws [ColumnOperationException] if either index is out of range.
  void reorderTask(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= tasks.length ||
        newIndex < 0 ||
        newIndex > tasks.length) {
      throw ColumnOperationException('reorderTask - Index out of range');
    }
    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);
  }

  /// Deletes and returns the task at the specified index.
  ///
  /// Throws [ColumnOperationException] if the index is out of range.
  Task deleteTask(int index) {
    if (index < 0 || index >= tasks.length) {
      throw ColumnOperationException('reorderTask - Index out of range');
    }
    return tasks.removeAt(index);
  }

  /// Moves a task from this column to another column.
  ///
  /// [sourceIndex] specifies which task to move.
  /// [destination] specifies the target column.
  /// [destinationIndex] optionally specifies where in the target column to insert the task.
  ///
  /// Throws:
  /// * [ColumnOperationException] if source index is invalid
  /// * [ColumnLimitExceededException] if destination column would exceed its limit
  void moveTaskTo(int sourceIndex, KanbanColumn destination, [int? destinationIndex]) {
    // Ensure source index is valid.
    if (sourceIndex < 0 || sourceIndex >= tasks.length) {
      throw ColumnOperationException('moveTaskTo - Source index out of range');
    }
    // Ensure destination column limit is obeyed.
    if (destination.columnLimit != null &&
        destination.tasks.length >= destination.columnLimit!) {
      throw ColumnLimitExceededException(destination.id);
    }
    final task = deleteTask(sourceIndex);
    if (destinationIndex == null ||
        destinationIndex < 0 ||
        destinationIndex > destination.tasks.length) {
      destination.tasks.add(task);
    } else {
      destination.tasks.insert(destinationIndex, task);
    }
  }

  /// Replaces the task at the specified index with an updated version.
  ///
  /// Throws [ColumnOperationException] if the index is out of range.
  void replaceTask(int index, Task updatedTask) {
    if (index < 0 || index >= tasks.length) {
      throw ColumnOperationException('replaceTask - Index out of range');
    }
    tasks[index] = updatedTask;
  }

  /// Converts the column to a JSON-compatible map for persistence.
  ///
  /// Includes all tasks and column configuration.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'header': header,
      'limit': columnLimit,
      'canAddTask': canAddTask,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  /// Checks if this is the "Done" column.
  ///
  /// Returns true if the column header (case-insensitive) is "done".
  bool isDoneColumn() {
    return header.toLowerCase() == 'done';
  }
}
