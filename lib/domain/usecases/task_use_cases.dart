import '../entities/task.dart';
import '../entities/column.dart';

class AddTaskUseCase {
  /// Adds a task to the given column.
  void execute(Column column, Task task) {
    column.addTask(task);
  }
}

class DeleteTaskUseCase {
  /// Deletes a task at the specified index from the column.
  ///
  /// Returns the removed task.
  Task execute(Column column, int index) {
    return column.deleteTask(index);
  }
}

class ReorderTaskUseCase {
  /// Reorders a task within the same column.
  void execute(Column column, int oldIndex, int newIndex) {
    column.reorderTask(oldIndex, newIndex);
  }
}

class MoveTaskUseCase {
  /// Moves a task from the source column to the destination column.
  ///
  /// Optionally, a destination index can be provided.
  void execute(Column source, int sourceIndex, Column destination, [int? destinationIndex]) {
    source.moveTaskTo(sourceIndex, destination, destinationIndex);
  }
}
