import 'package:flutter_test/flutter_test.dart';
import 'package:clean_kanban/domain/entities/task.dart';
import 'package:clean_kanban/domain/entities/column.dart';
import 'package:clean_kanban/domain/usecases/task_use_cases.dart';

void main() {
  group('Task Use Cases', () {
    late KanbanColumn column;
    late KanbanColumn destination;
    late AddTaskUseCase addTaskUseCase;
    late DeleteTaskUseCase deleteTaskUseCase;
    late ReorderTaskUseCase reorderTaskUseCase;
    late MoveTaskUseCase moveTaskUseCase;

    setUp(() {
      column = KanbanColumn(id: 'col1', header: 'To Do', columnLimit: 3);
      destination = KanbanColumn(id: 'col2', header: 'Done', columnLimit: 2);
      addTaskUseCase = AddTaskUseCase();
      deleteTaskUseCase = DeleteTaskUseCase();
      reorderTaskUseCase = ReorderTaskUseCase();
      moveTaskUseCase = MoveTaskUseCase();
    });

    test('should add a task to a column using AddTaskUseCase', () {
      // Arrange
      final task = Task(id: '1', title: 'Task1', subtitle: 'Desc1');

      // Act
      addTaskUseCase.execute(column, task);

      // Assert
      expect(column.tasks.length, equals(1));
      expect(column.tasks.first, equals(task));
    });

    test('should delete a task from a column using DeleteTaskUseCase', () {
      // Arrange
      final task = Task(id: '1', title: 'Task1', subtitle: 'Desc1');
      column.addTask(task);

      // Act
      final removed = deleteTaskUseCase.execute(column, 0);

      // Assert
      expect(removed, equals(task));
      expect(column.tasks, isEmpty);
    });

    test('should reorder tasks in a column using ReorderTaskUseCase', () {
      // Arrange
      final task1 = Task(id: '1', title: 'Task1', subtitle: 'Desc1');
      final task2 = Task(id: '2', title: 'Task2', subtitle: 'Desc2');
      final task3 = Task(id: '3', title: 'Task3', subtitle: 'Desc3');
      column.addTask(task1);
      column.addTask(task2);
      column.addTask(task3);

      // Act: move first task to last index.
      reorderTaskUseCase.execute(column, 0, 2);

      // Assert
      expect(column.tasks[0], equals(task2));
      expect(column.tasks[1], equals(task3));
      expect(column.tasks[2], equals(task1));
    });

    test('should move a task from one column to another using MoveTaskUseCase', () {
      // Arrange
      final task = Task(id: '1', title: 'Task1', subtitle: 'Desc1');
      column.addTask(task);

      // Act
      moveTaskUseCase.execute(column, 0, destination);

      // Assert
      expect(column.tasks, isEmpty);
      expect(destination.tasks.length, equals(1));
      expect(destination.tasks.first, equals(task));
    });

    test('should throw error if moving task to a full column using MoveTaskUseCase', () {
      // Arrange
      final task1 = Task(id: '1', title: 'Task1', subtitle: 'Desc1');
      final task2 = Task(id: '2', title: 'Task2', subtitle: 'Desc2');
      final task3 = Task(id: '3', title: 'Task3', subtitle: 'Desc3');
      destination.addTask(task3);
      destination.addTask(task1); // destination now full for this test (limit: 2, will be reached after move if already at limit)
      column.addTask(task2);

      // Act & Assert
      expect(() => moveTaskUseCase.execute(column, 0, destination), throwsA(isA<Exception>()));
    });

    test('should throw error when adding a task to a full column using AddTaskUseCase', () {
      // Arrange
      final fullColumn = KanbanColumn(id: 'colFull', header: 'Full Column', columnLimit: 1);
      final task1 = Task(id: '1', title: 'Task1', subtitle: 'Desc1');
      final task2 = Task(id: '2', title: 'Task2', subtitle: 'Desc2');
      addTaskUseCase.execute(fullColumn, task1);
      
      // Act & Assert
      expect(() => addTaskUseCase.execute(fullColumn, task2), throwsA(isA<Exception>()));
    });
  });
}
