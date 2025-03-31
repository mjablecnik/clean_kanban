import 'task.dart';

class KanbanColumn {
  final String id;
  final String header;
  final int? columnLimit;
  final List<Task> tasks = [];
  final bool canAddTask; // always allow to add task by default

  KanbanColumn(
      {required this.id,
      required this.header,
      this.columnLimit,
      this.canAddTask = true});

  void addTask(Task task) {
    // Ensure column limit is obeyed when adding a new task.
    if (columnLimit != null && tasks.length >= columnLimit!) {
      throw Exception('Column limit reached.');
    }
    tasks.add(task);
  }

  void reorderTask(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= tasks.length ||
        newIndex < 0 ||
        newIndex > tasks.length) {
      throw RangeError('Index out of range');
    }
    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);
  }

  Task deleteTask(int index) {
    if (index < 0 || index >= tasks.length) {
      throw RangeError('Index out of range');
    }
    return tasks.removeAt(index);
  }

  void moveTaskTo(int sourceIndex, KanbanColumn destination, [int? destinationIndex]) {
    // Ensure source index is valid.
    if (sourceIndex < 0 || sourceIndex >= tasks.length) {
      throw RangeError('Source index out of range');
    }
    // Ensure destination column limit is obeyed.
    if (destination.columnLimit != null &&
        destination.tasks.length >= destination.columnLimit!) {
      throw Exception('Destination column limit reached.');
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

  // Convert column to JSON format for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'header': header,
      'limit': columnLimit,
      'canAddTask': canAddTask,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  bool isDoneColumn() {
    return header.toLowerCase() == 'done';
  }
}
