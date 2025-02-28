import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_kanban/ui/widgets/task_card.dart';
import 'package:clean_kanban/domain/entities/task.dart';

void main() {
  testWidgets('TaskCard displays task title and subtitle',
      (WidgetTester tester) async {
    // Arrange
    final testTask =
        Task(id: '1', title: 'Test Title', subtitle: 'Test Subtitle');

    await tester.pumpWidget(
      MaterialApp(
        home: TaskCard(task: testTask),
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
          task: testTask,
          onMoveLeft: () {
            movedLeft = true;
          },
          onMoveRight: () {
            movedRight = true;
          },
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
}
