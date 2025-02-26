import 'column.dart';
import 'task.dart';

class Board {
  final List<KanbanColumn> columns;

  Board._(this.columns);

  // Creates a simple board with exactly 3 default columns.
  factory Board.simple() {
    return Board._([
      KanbanColumn(id: 'todo', header: 'To Do', columnLimit: null),
      KanbanColumn(id: 'doing', header: 'Doing', columnLimit: null),
      KanbanColumn(id: 'done', header: 'Done', columnLimit: null),
    ]);
  }

  // Creates an enhanced board with custom columns. Must have at least 3 columns.
  factory Board({required List<KanbanColumn> columns}) {
    if (columns.length < 3) {
      throw Exception('Enhanced board must have at least 3 columns.');
    }
    return Board._(columns);
  }

  factory Board.fromConfig(Map<String, dynamic> config) {
    if (!config.containsKey('columns')) {
      throw ArgumentError('Configuration must contain columns');
    }

    final columns = (config['columns'] as List).map((colConfig) {
      if (!colConfig.containsKey('id') || !colConfig.containsKey('header')) {
        throw ArgumentError('Column configuration must contain id and header');
      }

      final column = KanbanColumn(
        id: colConfig['id'],
        header: colConfig['header'],
        columnLimit: colConfig['limit'],
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
}
