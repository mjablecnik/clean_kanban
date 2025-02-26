import 'column.dart';

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
}
