import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_kanban/ui/widgets/column_widget.dart';
import 'package:clean_kanban/domain/entities/column.dart';
import 'package:clean_kanban/domain/entities/task.dart';

void main() {
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
          body: ColumnWidget(column: testColumn),
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
            onAddTask: (title, subtitle) {
              testColumn
                  .addTask(Task(id: '1', title: title, subtitle: subtitle));
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
}
