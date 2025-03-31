import 'package:clean_kanban/domain/entities/task.dart';
import 'package:clean_kanban/domain/entities/column.dart';

class TaskDragData {
  final Task task;
  final KanbanColumn sourceColumn;
  final int sourceIndex;

  TaskDragData({
    required this.task,
    required this.sourceColumn,
    required this.sourceIndex,
  });
}
