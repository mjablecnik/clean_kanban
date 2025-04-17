import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_kanban/ui/widgets/column_widget.dart';
import 'package:clean_kanban/domain/entities/column.dart';
import 'package:clean_kanban/domain/entities/task.dart';
import 'package:clean_kanban/ui/theme/kanban_theme.dart';

void main() {
  final columnTheme = KanbanColumnTheme();
  testWidgets('ColumnWidget displays header and tasks',
      (WidgetTester tester) async {
    // Arrange: Create a test column with two tasks.
    final testColumn =
        KanbanColumn(id: 'col1', header: 'Test Column', columnLimit: null);
    testColumn.addTask(Task(id: '1', title: 'Task1', subtitle: 'Desc1'));
    testColumn.addTask(Task(id: '2', title: 'Task2', subtitle: 'Desc2'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ColumnWidget(
            column: testColumn,
            theme: columnTheme,
          ),
        ),
      ),
    );

    // Assert: The header and tasks are displayed.
    expect(find.text('Test Column'), findsOneWidget);
    expect(find.text('Task1'), findsOneWidget);
    expect(find.text('Task2'), findsOneWidget);
  });

  // test add task
  testWidgets('ColumnWidget adds a task when tapped',
      (WidgetTester tester) async {
    // Arrange: Create a test column with no tasks.
    final testColumn =
        KanbanColumn(id: 'col1', header: 'Test Column', columnLimit: null);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ColumnWidget(
            column: testColumn,
            theme: columnTheme,
            onAddTask: () {
              testColumn
                  .addTask(Task(id: '1', title: 'title', subtitle: 'subtitle'));
            },
          ),
        ),
      ),
    );

    // Act: Tap the add_rounded icon button to add new task
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    // Assert: The task is added to the column.
    expect(testColumn.tasks.length, equals(1));
  });

  testWidgets('Clear button shows only in Done column with tasks',
      (WidgetTester tester) async {
    final doneColumn = KanbanColumn(
      id: 'done',
      header: 'Done',
    );
    final task = Task(id: '1', title: 'Test Task', subtitle: 'Test');
    doneColumn.addTask(task);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ColumnWidget(
          column: doneColumn,
          theme: const KanbanColumnTheme(),
          onClearDone: () {},
        ),
      ),
    ));

    expect(find.byIcon(Icons.clear_all), findsOneWidget);
  });

  testWidgets('Clear button not shown in non-Done column',
      (WidgetTester tester) async {
    final todoColumn = KanbanColumn(
      id: 'todo',
      header: 'To Do',
    );
    final task = Task(id: '1', title: 'Test Task', subtitle: 'Test');
    todoColumn.addTask(task);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ColumnWidget(
          column: todoColumn,
          theme: const KanbanColumnTheme(),
          onClearDone: () {},
        ),
      ),
    ));

    expect(find.byIcon(Icons.clear_all), findsNothing);
  });

  testWidgets('Clear button shows confirmation dialog',
      (WidgetTester tester) async {
    bool clearCalled = false;
    final doneColumn = KanbanColumn(
      id: 'done',
      header: 'Done',
    );
    final task = Task(id: '1', title: 'Test Task', subtitle: 'Test');
    doneColumn.addTask(task);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ColumnWidget(
          column: doneColumn,
          theme: const KanbanColumnTheme(),
          onClearDone: () => clearCalled = true,
        ),
      ),
    ));

    await tester.tap(find.byIcon(Icons.clear_all));
    await tester.pumpAndSettle();

    expect(find.text('Clear all done tasks'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);

    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(clearCalled, true);
  });
}
