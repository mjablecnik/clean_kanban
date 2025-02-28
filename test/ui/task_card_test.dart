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
}
