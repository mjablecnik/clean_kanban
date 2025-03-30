import '../entities/task.dart';
import '../entities/column.dart';
import '../events/event_notifier.dart';
import '../events/board_events.dart';

class AddTaskUseCase {
  /// Adds a task to the given column.
  void execute(KanbanColumn column, Task task) {
    column.addTask(task);
    EventNotifier().notify(TaskAddedEvent(task, column));
  }
}

class DeleteTaskUseCase {
  /// Deletes a task at the specified index from the column.
  ///
  /// Returns the removed task.
  Task execute(KanbanColumn column, int index) {
    final removed = column.deleteTask(index);
    EventNotifier().notify(TaskRemovedEvent(removed, column));
    return removed;
  }
}

class ReorderTaskUseCase {
  /// Reorders a task within the same column.
  void execute(KanbanColumn column, int oldIndex, int newIndex) {
    Task task = column.tasks[oldIndex];
    column.reorderTask(oldIndex, newIndex);
    EventNotifier()
        .notify(TaskReorderedEvent(column, task, oldIndex, newIndex));
  }
}

class MoveTaskUseCase {
  /// Moves a task from the source column to the destination column.
  ///
  /// Optionally, a destination index can be provided.
  void execute(KanbanColumn source, int sourceIndex, KanbanColumn destination,
      [int? destinationIndex]) {
    // Capture the task before moving.
    final task = source.tasks[sourceIndex];
    source.moveTaskTo(sourceIndex, destination, destinationIndex);
    EventNotifier().notify(TaskMovedEvent(task, source, destination));
  }
}

class DeleteDoneTaskUseCase {
  /// Deletes a single task from the Done column.
  /// 
  /// Returns the removed task.
  Task execute(KanbanColumn doneColumn, int index) {
    if (!doneColumn.isDoneColumn()) {
      throw ArgumentError('This operation is only allowed for Done column');
    }
    final removed = doneColumn.deleteTask(index);
    EventNotifier().notify(TaskRemovedEvent(removed, doneColumn));
    return removed;
  }
}

class ClearDoneColumnUseCase {
  /// Removes all tasks from the Done column.
  /// 
  /// Returns the list of removed tasks.
  List<Task> execute(KanbanColumn doneColumn) {
    if (!doneColumn.isDoneColumn()) {
      throw ArgumentError('This operation is only allowed for Done column');
    }
    final removedTasks = List<Task>.from(doneColumn.tasks);
    doneColumn.tasks.clear();
    EventNotifier().notify(DoneColumnClearedEvent(removedTasks, doneColumn));
    return removedTasks;
  }
}
