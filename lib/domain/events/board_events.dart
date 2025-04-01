import '../entities/board.dart';
import '../entities/task.dart';
import '../entities/column.dart';

abstract class BoardEvent {}

class BoardLoadedEvent extends BoardEvent {
  final Board board;
  BoardLoadedEvent(this.board);
}

class BoardSavedEvent extends BoardEvent {
  final Board board;
  BoardSavedEvent(this.board);
}

// Task-related events
class TaskAddedEvent extends BoardEvent {
  final Task task;
  final KanbanColumn column;
  TaskAddedEvent(this.task, this.column);
}

class TaskRemovedEvent extends BoardEvent {
  final Task task;
  final KanbanColumn column;
  TaskRemovedEvent(this.task, this.column);
}

class TaskMovedEvent extends BoardEvent {
  final Task task;
  final KanbanColumn source;
  final KanbanColumn destination;
  TaskMovedEvent(this.task, this.source, this.destination);
}

class TaskReorderedEvent extends BoardEvent {
  final KanbanColumn column;
  final Task task;
  final int oldIndex;
  final int newIndex;
  TaskReorderedEvent(this.column, this.task, this.oldIndex, this.newIndex);
}

class DoneColumnClearedEvent extends BoardEvent {
  final List<Task> removedTasks;
  final KanbanColumn column;

  DoneColumnClearedEvent(this.removedTasks, this.column);
}

class TaskEditedEvent extends BoardEvent {
  final Task oldTask;
  final Task newTask;
  final KanbanColumn column;

  TaskEditedEvent(this.oldTask, this.newTask, this.column);
}