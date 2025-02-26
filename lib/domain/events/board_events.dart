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
