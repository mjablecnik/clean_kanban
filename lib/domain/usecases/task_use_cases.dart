import '../entities/task.dart';
import '../entities/column.dart';
import '../events/event_notifier.dart';
import '../events/board_events.dart';

class AddTaskUseCase {
  /// Adds a task to the given column.
  void execute(Column column, Task task) {
    column.addTask(task);
    EventNotifier().notify(TaskAddedEvent(task, column));
  }
}

class DeleteTaskUseCase {
  /// Deletes a task at the specified index from the column.
  ///
  /// Returns the removed task.
  Task execute(Column column, int index) {
    final removed = column.deleteTask(index);
    EventNotifier().notify(TaskRemovedEvent(removed, column));
    return removed;
  }
}

class ReorderTaskUseCase {
  /// Reorders a task within the same column.
  void execute(Column column, int oldIndex, int newIndex) {
    column.reorderTask(oldIndex, newIndex);
    // (Optional) Add an event if needed.
  }
}

class MoveTaskUseCase {
  /// Moves a task from the source column to the destination column.
  ///
  /// Optionally, a destination index can be provided.
  void execute(Column source, int sourceIndex, Column destination, [int? destinationIndex]) {
    // Capture the task before moving.
    final task = source.tasks[sourceIndex];
    source.moveTaskTo(sourceIndex, destination, destinationIndex);
    EventNotifier().notify(TaskMovedEvent(task, source, destination));
  }
}
