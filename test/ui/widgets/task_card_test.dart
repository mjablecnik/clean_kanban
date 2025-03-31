import 'package:clean_kanban/clean_kanban.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_kanban/ui/widgets/task_card.dart';
import 'package:clean_kanban/domain/entities/task.dart';
import 'package:clean_kanban/ui/widgets/task_drag_data.dart';

void main() {
  final cardTheme = TaskCardTheme();
  final column = KanbanColumn(
      id: '1',
      header: 'To Do',
    );
    
  testWidgets('TaskCard displays task title and subtitle',
      (WidgetTester tester) async {
    // Arrange
    
    final testTask =
        Task(id: '1', title: 'Test Title', subtitle: 'Test Subtitle');

    await tester.pumpWidget(
      MaterialApp(
        home: TaskCard(
          data: TaskDragData(
            task: testTask,
            sourceColumn: column,
            sourceIndex: 0,
          ),
          theme: cardTheme,
        ),
      ),
    );

    // Assert
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Subtitle'), findsOneWidget);
  });

  testWidgets('TaskCard move buttons work correctly',
      (WidgetTester tester) async {
    // Arrange
    final testTask =
        Task(id: '1', title: 'Test Title', subtitle: 'Test Subtitle');
    bool movedLeft = false;
    bool movedRight = false;

    await tester.pumpWidget(
      MaterialApp(
        home: TaskCard(
          data: TaskDragData(
            task: testTask,
            sourceColumn: column,
            sourceIndex: 0,
          ),
          theme: cardTheme,
          onMoveLeft: () {
            movedLeft = true;
          },
          onMoveRight: () {
            movedRight = true;
          },
          canMoveLeft: true,
          canMoveRight: true,
        ),
      ),
    );

    // Act: Tap the move left button.
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();

    // Assert: The move left callback should be triggered.
    expect(movedLeft, isTrue);

    // Act: Tap the move right button.
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();

    // Assert: The move right callback should be triggered.
    expect(movedRight, isTrue);
  });

  testWidgets('TaskCard move buttons are disabled correctly',
      (WidgetTester tester) async {
    // Arrange
    final testTask =
        Task(id: '1', title: 'Test Title', subtitle: 'Test Subtitle');

    await tester.pumpWidget(
      MaterialApp(
        home: TaskCard(
          data: TaskDragData(
            task: testTask,
            sourceColumn: column,
            sourceIndex: 0,
          ),
          theme: cardTheme,
          onMoveLeft: () {},
          onMoveRight: () {},
          canMoveLeft: false,
          canMoveRight: false,
        ),
      ),
    );

    // Assert: The move left and move right buttons should be disabled.
    final iconButtonFinder = find.byType(InkWell);
    tester.widgetList<InkWell>(iconButtonFinder).forEach((element) {
      expect(element.onTap, isNull);
    });
  });
}
