import 'column.dart';

class Board {
  final List<Column> columns;

  Board._(this.columns);

  // Creates a simple board with exactly 3 default columns.
  factory Board.simple() {
    return Board._([
      Column(id: 'todo', header: 'To Do', columnLimit: null),
      Column(id: 'doing', header: 'Doing', columnLimit: null),
      Column(id: 'done', header: 'Done', columnLimit: null),
    ]);
  }

  // Creates an enhanced board with custom columns. Must have at least 3 columns.
  factory Board({required List<Column> columns}) {
    if (columns.length < 3) {
      throw Exception('Enhanced board must have at least 3 columns.');
    }
    return Board._(columns);
  }
}
