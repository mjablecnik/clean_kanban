import 'package:flutter_test/flutter_test.dart';
import 'package:clean_kanban/ui/providers/board_provider.dart';
import 'package:clean_kanban/domain/entities/task.dart';
import 'package:clean_kanban/domain/entities/board.dart';
import 'package:clean_kanban/domain/entities/column.dart';
import 'package:clean_kanban/injection_container.dart';
import '../../domain/repositories/test_board_repository.dart';

void main() {
  setUpAll(() async {
    // Reset and setup injection so dependencies are registered.
    await getIt.reset();
    setupInjection(TestBoardRepository());
  });

  group('BoardProvider', () {
    test('should load a simple board if no board exists', () async {
      // Arrange
      final boardProvider = BoardProvider();

      // Act
      await boardProvider.loadBoard();

      // Assert
      expect(boardProvider.board, isNotNull);
      expect(boardProvider.board!.columns.length, equals(3));
      expect(boardProvider.board!.columns[0].header, equals('To Do'));
    });

    test('should load a board with custom configuration', () async {
      // Arrange
      final config = {
        'columns': [
          {
            'id': 'todo',
            'header': 'To Do',
            'limit': 5,
            'tasks': [
              {'id': '1', 'title': 'Task 1', 'subtitle': 'Description 1'},
              {'id': '2', 'title': 'Task 2', 'subtitle': 'Description 2'},
            ]
          },
          {'id': 'doing', 'header': 'In Progress', 'limit': 3, 'tasks': []},
          {
            'id': 'done',
            'header': 'Done',
            'limit': null,
            'tasks': [
              {'id': '3', 'title': 'Task 3', 'subtitle': 'Description 3'}
            ]
          }
        ]
      };
      final boardProvider = BoardProvider();

      // Act
      await boardProvider.loadBoard(config: config);

      // Assert
      expect(boardProvider.board, isNotNull);
      expect(boardProvider.board!.columns.length, equals(3));
      expect(boardProvider.board!.columns[0].header, equals('To Do'));
      expect(boardProvider.board!.columns[0].tasks.length, equals(2));
      expect(boardProvider.board!.columns[1].tasks, isEmpty);
      expect(boardProvider.board!.columns[2].tasks.length, equals(1));
    });

    test('should add a task to a column', () {
      // Arrange
      final boardProvider = BoardProvider();
      boardProvider.board = Board.simple();
      final task = Task(id: '1', title: 'Task1', subtitle: 'Desc1');

      // Act
      boardProvider.addTask('todo', task);

      // Assert
      final column =
          boardProvider.board!.columns.firstWhere((c) => c.id == 'todo');
      expect(column.tasks.length, equals(1));
      expect(column.tasks.first, equals(task));
    });

    test('should remove a task from a column', () {
      // Arrange
      final boardProvider = BoardProvider();
      boardProvider.board = Board.simple();
      final task = Task(id: '1', title: 'Task1', subtitle: 'Desc1');
      boardProvider.addTask('todo', task);

      // Act
      boardProvider.removeTask('todo', 0);

      // Assert
      final column =
          boardProvider.board!.columns.firstWhere((c) => c.id == 'todo');
      expect(column.tasks, isEmpty);
    });

    test('should move a task from one column to another', () {
      // Arrange
      final boardProvider = BoardProvider();
      boardProvider.board = Board.simple();
      final task = Task(id: '1', title: 'Task1', subtitle: 'Desc1');
      boardProvider.addTask('todo', task);

      // Act
      boardProvider.moveTask('todo', 0, 'doing');

      // Assert
      final sourceColumn =
          boardProvider.board!.columns.firstWhere((c) => c.id == 'todo');
      final destColumn =
          boardProvider.board!.columns.firstWhere((c) => c.id == 'doing');
      expect(sourceColumn.tasks, isEmpty);
      expect(destColumn.tasks.length, equals(1));
      expect(destColumn.tasks.first, equals(task));
    });

    test('should reorder the task within the same column', () {
      // Arrange
      final boardProvider = BoardProvider();
      boardProvider.board = Board.simple();
      final task = Task(id: '1', title: 'Task1', subtitle: 'Desc1');
      final task2 = Task(id: '2', title: 'Task2', subtitle: 'Desc2');
      boardProvider.addTask('todo', task);
      boardProvider.addTask('todo', task2);

      // Act
      boardProvider.reorderTask('todo', 1, 0);

      // Assert
      final column =
          boardProvider.board!.columns.firstWhere((c) => c.id == 'todo');
      expect(column.tasks[0], equals(task2), reason: 'Task2 should be first');
      expect(column.tasks[1], equals(task));
    });
  });
}
