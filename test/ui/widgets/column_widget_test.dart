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

  // test move task from left to right
  testWidgets('ColumnWidget moves a task from left to right',
      (WidgetTester tester) async {
    // Arrange: Create two test columns with one task each.
    final leftColumn =
        KanbanColumn(id: 'left', header: 'Left Column', columnLimit: null);
    leftColumn.addTask(Task(id: '1', title: 'Task1', subtitle: 'Desc1'));

    final rightColumn =
        KanbanColumn(id: 'right', header: 'Right Column', columnLimit: null);
    rightColumn.addTask(Task(id: '2', title: 'Task2', subtitle: 'Desc2'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              Expanded(
                child: ColumnWidget(
                  column: leftColumn,
                  onMoveTaskLeftToRight: (sourceTaskIndex) {
                    leftColumn.moveTaskTo(sourceTaskIndex, rightColumn);
                  },
                ),
              ),
              Expanded(
                child: ColumnWidget(
                  column: rightColumn,
                ),
              )
            ],
          ),
        ),
      ),
    );

    // Precondition: each column has 1 task, .
    expect(leftColumn.tasks.length, equals(1));
    expect(rightColumn.tasks.length, equals(1));

    // Act: Click on the chevron_right in the task card to move the task to the right column.
    // Find button by both column header and button text
    final buttonFinder = find.descendant(
      of: find.ancestor(
        of: find.text('Left Column'),
        matching: find.byType(Column),
      ),
      matching: find.byIcon(Icons.chevron_right),
    );
    await tester.tap(buttonFinder.first);
    await tester.pumpAndSettle();

    // // Assert: The task is moved from left to right column.
    expect(leftColumn.tasks.length, equals(0));
    expect(rightColumn.tasks.length, equals(2));
  });

  testWidgets('ColumnWidget moves a task from right to left',
      (WidgetTester tester) async {
    // Arrange: Create two test columns with one task each.
    final leftColumn =
        KanbanColumn(id: 'left', header: 'Left Column', columnLimit: null);
    leftColumn.addTask(Task(id: '1', title: 'Task1', subtitle: 'Desc1'));

    final rightColumn =
        KanbanColumn(id: 'right', header: 'Right Column', columnLimit: null);
    rightColumn.addTask(Task(id: '2', title: 'Task2', subtitle: 'Desc2'));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              Expanded(
                child: ColumnWidget(
                  column: leftColumn,
                ),
              ),
              Expanded(
                child: ColumnWidget(
                  column: rightColumn,
                  onMoveTaskRightToLeft: (sourceTaskIndex) {
                    rightColumn.moveTaskTo(sourceTaskIndex, leftColumn);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );

    // Precondition: each column has 1 task, .
    expect(leftColumn.tasks.length, equals(1));
    expect(rightColumn.tasks.length, equals(1));

    // Act: Click on the chevron_left in the task card to move the task to the left column.
    // Find button by both column header and button text
    final buttonFinder = find.descendant(
      of: find.ancestor(
        of: find.text('Right Column'),
        matching: find.byType(Column),
      ),
      matching: find.byIcon(Icons.chevron_left),
    );
    await tester.tap(buttonFinder.first);
    await tester.pumpAndSettle();

    // // Assert: The task is moved from left to right column.
    expect(leftColumn.tasks.length, equals(2));
    expect(rightColumn.tasks.length, equals(0));
  });
}
