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
}
