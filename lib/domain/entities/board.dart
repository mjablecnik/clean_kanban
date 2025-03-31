import 'column.dart';
import 'task.dart';
import '../../core/exceptions.dart';

class Board {
  final List<KanbanColumn> columns;

  Board._(this.columns);

  // Creates a simple board with exactly 3 default columns.
  factory Board.simple() {
    return Board._([
      KanbanColumn(id: 'todo', header: 'To Do', columnLimit: null),
      KanbanColumn(
          id: 'doing', header: 'Doing', columnLimit: null, canAddTask: false),
      KanbanColumn(
          id: 'done', header: 'Done', columnLimit: null, canAddTask: false),
    ]);
  }

  // Creates an enhanced board with custom columns. Must have at least 3 columns.
  factory Board({required List<KanbanColumn> columns}) {
    if (columns.length < 3) {
      throw KanbanBoardMinimumColumnRequirementException();
    }
    return Board._(columns);
  }

  factory Board.fromConfig(Map<String, dynamic> config) {
    if (!config.containsKey('columns')) {
      throw BoardConfigColumnsRequirementException();
    }

    final columns = (config['columns'] as List).map((colConfig) {
      if (!colConfig.containsKey('id') || !colConfig.containsKey('header')) {
        throw BoardConfigMandatoryFieldsException();
      }

      final column = KanbanColumn(
        id: colConfig['id'],
        header: colConfig['header'],
        columnLimit: colConfig['limit'],
        canAddTask: colConfig['canAddTask'] ?? true,
      );

      if (colConfig['tasks'] != null) {
        for (final taskConfig in colConfig['tasks']) {
          final task = Task(
            id: taskConfig['id'],
            title: taskConfig['title'],
            subtitle: taskConfig['subtitle'],
          );
          column.addTask(task);
        }
      }

      return column;
    }).toList();

    return Board(columns: columns);
  }

  // return the id of the column on the left of the given column, return null if not found
  bool hasLeftColumn(String columnId) {
    final index = columns.indexWhere((col) => col.id == columnId);
    if (index == -1 || index == 0) {
      return false;
    }
    return true;
  }

  String? getLeftColumnId(String columnId) {
    final index = columns.indexWhere((col) => col.id == columnId);
    if (index == -1 || index == 0) {
      return null;
    }
    return columns[index - 1].id;
  }

  bool hasRightColumn(String columnId) {
    final index = columns.indexWhere((col) => col.id == columnId);
    if (index == -1 || index == columns.length - 1) {
      return false;
    }
    return true;
  }

  String? getRightColumnId(String columnId) {
    final index = columns.indexWhere((col) => col.id == columnId);
    if (index == -1 || index == columns.length - 1) {
      return null;
    }
    return columns[index + 1].id;
  }

  // function return true if column reached its limit
  bool isColumnLimitReached(String columnId) {
    final column = columns.firstWhere((col) => col.id == columnId);
    if (column.columnLimit != null &&
        column.tasks.length >= column.columnLimit!) {
      return true;
    }
    return false;
  }

  // Convert board to JSON format for persistence
  Map<String, dynamic> toJson() {
    return {
      'columns': columns.map((column) => column.toJson()).toList(),
    };
  }
}
