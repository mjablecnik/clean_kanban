import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:clean_kanban/ui/widgets/board_widget.dart';
import 'package:clean_kanban/ui/providers/board_provider.dart';
import 'package:clean_kanban/injection_container.dart';
import 'package:clean_kanban/domain/entities/board.dart';
import '../domain/repositories/test_board_repository.dart';

void main() {
  setUpAll(() async {
    // Reset and setup injection so dependencies are registered.
    await getIt.reset();
    setupInjection(TestBoardRepository());
  });

  testWidgets('BoardWidget shows loading indicator then board UI',
      (WidgetTester tester) async {
    // Arrange: Create a BoardProvider that initially has a null board.
    final boardProvider = BoardProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<BoardProvider>.value(
        value: boardProvider,
        child: const MaterialApp(home: BoardWidget()),
      ),
    );

    // Assert: Should show a loading indicator while board is null.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Act: Simulate board load by assigning a simple board and notifying listeners.
    boardProvider.board =
        boardProvider.board ?? BoardProvider().board ?? Board.simple();
    boardProvider.notifyListeners();
    await tester.pumpAndSettle();

    // Assert: Now we expect the columns to be visible.
    expect(find.text('To Do'), findsOneWidget);
    expect(find.text('Doing'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
  });

  testWidgets('BoardWidget displays tasks within columns',
      (WidgetTester tester) async {
    // Arrange: Create a BoardProvider with a board containing tasks.
    final boardProvider = BoardProvider();
    boardProvider.board = Board.fromConfig({
      'columns': [
        {
          'id': 'todo',
          'header': 'To Do',
          'tasks': [
            {'id': '1', 'title': 'Task 1', 'subtitle': 'Description 1'},
          ]
        },
        {
          'id': 'doing',
          'header': 'Doing',
          'tasks': [
            {'id': '2', 'title': 'Task 2', 'subtitle': 'Description 2'},
          ]
        },
        {
          'id': 'done',
          'header': 'Done',
          'tasks': [
            {'id': '3', 'title': 'Task 3', 'subtitle': 'Description 3'},
          ]
        },
      ]
    });

    await tester.pumpWidget(
      ChangeNotifierProvider<BoardProvider>.value(
        value: boardProvider,
        child: const MaterialApp(home: BoardWidget()),
      ),
    );

    // Assert: Tasks should be displayed within their respective columns.
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 2'), findsOneWidget);
    expect(find.text('Task 3'), findsOneWidget);
  });

  testWidgets('BoardWidget onAddTask callback works correctly',
      (WidgetTester tester) async {
    // Arrange: Create a BoardProvider with a board containing columns.
    final boardProvider = BoardProvider();
    boardProvider.board = Board.fromConfig({
      'columns': [
        {'id': 'todo', 'header': 'To Do', 'tasks': []},
        {'id': 'doing', 'header': 'Doing', 'tasks': []},
        {'id': 'done', 'header': 'Done', 'tasks': []},
      ]
    });

    await tester.pumpWidget(
      ChangeNotifierProvider<BoardProvider>.value(
        value: boardProvider,
        child: const MaterialApp(home: BoardWidget()),
      ),
    );

    // Act: Simulate adding a new task.
    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await tester.pumpAndSettle();

    // Assert: The new task should be added to the column.
    expect(find.text('New Task'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
  });

  //TODO: fix this test
  // testWidgets('BoardWidget onReorderedTasks callback works correctly',
  //     (WidgetTester tester) async {
  //   // Arrange: Create a BoardProvider with a board containing columns.
  //   final boardProvider = BoardProvider();
  //   boardProvider.board = Board.fromConfig({
  //     'columns': [
  //       {
  //         'id': 'todo',
  //         'header': 'To Do',
  //         'tasks': [
  //           {'id': '1', 'title': 'Task 1', 'subtitle': 'Description 1'},
  //           {'id': '2', 'title': 'Task 2', 'subtitle': 'Description 2'},
  //           {'id': '3', 'title': 'Task 3', 'subtitle': 'Description 3'},
  //         ]
  //       },
  //       {'id': 'doing', 'header': 'Doing', 'tasks': []},
  //       {'id': 'done', 'header': 'Done', 'tasks': []},
  //     ]
  //   });

  //   await tester.pumpWidget(
  //     ChangeNotifierProvider<BoardProvider>.value(
  //       value: boardProvider,
  //       child: const MaterialApp(home: BoardWidget()),
  //     ),
  //   );

  //   // Act: Simulate reordering tasks within a column.
  //   await tester.drag(find.text('Task 1'), const Offset(0, 100));
  //   await tester.pumpAndSettle();

  //   // Assert: The tasks should be reordered within the column.
  //   final columnFinder = find.text('To Do');
  //   expect(find.descendant(of: columnFinder, matching: find.('Task 2')),
  //       findsOneWidget);
  //   expect(find.descendant(of: columnFinder, matching: find.text('Task 3')),
  //       findsOneWidget);
  //   expect(find.descendant(of: columnFinder, matching: find.text('Task 1')),
  //       findsOneWidget);
  // });
}
