import 'package:flutter_test/flutter_test.dart';
import 'package:clean_kanban/domain/entities/task.dart';

void main() {
  group('Task Entity', () {
    test('should create a valid task', () {
      // Arrange
      const id = '1';
      const title = 'A valid title';
      const subtitle = 'A valid subtitle';
      
      // Act
      final task = Task(id: id, title: title, subtitle: subtitle);
      
      // Assert
      expect(task.id, equals(id));
      expect(task.title, equals(title));
      expect(task.subtitle, equals(subtitle));
    });

    test('should throw error when title is longer than 100 characters', () {
      // Arrange
      const id = '2';
      final longTitle = 't' * 101;
      const subtitle = 'Valid subtitle';

      // Act & Assert
      expect(() => Task(id: id, title: longTitle, subtitle: subtitle),
          throwsA(isA<ArgumentError>()));
    });

    test('should throw error when subtitle is longer than 100 characters', () {
      // Arrange
      const id = '3';
      const title = 'Valid title';
      final longSubtitle = 's' * 101;

      // Act & Assert
      expect(() => Task(id: id, title: title, subtitle: longSubtitle),
          throwsA(isA<ArgumentError>()));
    });
  });
}
