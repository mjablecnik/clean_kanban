import '../entities/task.dart';
import '../entities/column.dart';
import '../events/event_notifier.dart';
import '../events/board_events.dart';
import '../../core/result.dart';
import '../../core/exceptions.dart';

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
  Result<Task> execute(KanbanColumn column, int index) {
    final removed = column.deleteTask(index);
    EventNotifier().notify(TaskRemovedEvent(removed, column));
    return Success(removed);
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
  void execute(KanbanColumn source, int sourceIndex, KanbanColumn destination, [int? destinationIndex]) {
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
  Result<Task> execute(KanbanColumn doneColumn, int index) {
    try {
      if (!doneColumn.isDoneColumn()) {
        throw OperationLimitedToDoneColumnException();
      }
      final removed = doneColumn.deleteTask(index);
      EventNotifier().notify(TaskRemovedEvent(removed, doneColumn));
      return Success(removed);
    } on OperationLimitedToDoneColumnException catch (e) {
      return Failure(e.message);
    } catch (e) {
      throw TaskOperationException('Failed to delete task: ${e.toString()}');
    }
  }
}

class ClearDoneColumnUseCase {
  /// Removes all tasks from the Done column.
  /// 
  /// Returns the list of removed tasks.
  Result<List<Task>> execute(KanbanColumn doneColumn) {
    try {
      if (!doneColumn.isDoneColumn()) {
        throw OperationLimitedToDoneColumnException();
      }
      final removedTasks = List<Task>.from(doneColumn.tasks);
      doneColumn.tasks.clear();
      EventNotifier().notify(DoneColumnClearedEvent(removedTasks, doneColumn));
      return Success(removedTasks);
    } on OperationLimitedToDoneColumnException catch (e) {
      return Failure(e.message);
    } catch (e) {
      throw TaskOperationException('Failed to clear Done column: ${e.toString()}');
    }
  }
}

class EditTaskUseCase {
  /// Edits an existing task at the specified index in the column.
  /// 
  /// Returns a Result indicating success or failure.
  /// Throws TaskOperationException if the task cannot be edited.
  Result<Task> execute(KanbanColumn column, int index, String newTitle, String newSubtitle) {
    try {
      final task = column.tasks[index];
      
      // Check if any changes are needed
      if (task.title == newTitle && task.subtitle == newSubtitle) {
        return Success(task);
      }

      final updatedTask = task.copyWith(
        title: newTitle,
        subtitle: newSubtitle,
      );
      
      column.replaceTask(index, updatedTask);
      EventNotifier().notify(TaskEditedEvent(task, updatedTask, column));
      return Success(updatedTask);
    } catch (e) {
      throw TaskOperationException('Failed to edit task: ${e.toString()}');
    }
  }
}
