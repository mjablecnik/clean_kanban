import 'package:flutter_test/flutter_test.dart';
import 'package:clean_kanban/domain/events/event_notifier.dart';
import 'package:clean_kanban/domain/events/board_events.dart';
import 'package:clean_kanban/domain/entities/board.dart';
import 'package:clean_kanban/domain/entities/column.dart';
import 'package:clean_kanban/domain/entities/task.dart';

void main() {
  group('EventNotifier', () {
    late EventNotifier notifier;

    setUp(() {
      // Reuse the singleton instance.
      notifier = EventNotifier();
    });

    test('should notify BoardLoadedEvent when board is loaded', () async {
      final board = Board.simple();
      final events = <BoardEvent>[];
      final subscription = notifier.stream.listen((event) {
        events.add(event);
      });

      notifier.notify(BoardLoadedEvent(board));
      await Future.delayed(Duration(milliseconds: 10));

      expect(events.length, equals(1));
      expect(events.first, isA<BoardLoadedEvent>());
      subscription.cancel();
    });

    test('should notify BoardSavedEvent when board is saved', () async {
      final board = Board.simple();
      final events = <BoardEvent>[];
      final subscription = notifier.stream.listen((event) {
        events.add(event);
      });

      notifier.notify(BoardSavedEvent(board));
      await Future.delayed(Duration(milliseconds: 10));

      expect(events.length, equals(1));
      expect(events.first, isA<BoardSavedEvent>());
      subscription.cancel();
    });

    test('should notify TaskAddedEvent when a task is added', () async {
      final column =
          KanbanColumn(id: 'col1', header: 'To Do', columnLimit: null);
      final task = Task(id: '1', title: 'Task1', subtitle: 'Desc1');
      final events = <BoardEvent>[];
      final subscription = notifier.stream.listen((event) {
        events.add(event);
      });

      notifier.notify(TaskAddedEvent(task, column));
      await Future.delayed(Duration(milliseconds: 10));

      expect(events.length, equals(1));
      expect(events.first, isA<TaskAddedEvent>());
      subscription.cancel();
    });

    test('should notify TaskRemovedEvent when a task is removed', () async {
      final column =
          KanbanColumn(id: 'col1', header: 'To Do', columnLimit: null);
      final task = Task(id: '1', title: 'Task1', subtitle: 'Desc1');
      final events = <BoardEvent>[];
      final subscription = notifier.stream.listen((event) {
        events.add(event);
      });

      notifier.notify(TaskRemovedEvent(task, column));
      await Future.delayed(Duration(milliseconds: 10));

      expect(events.length, equals(1));
      expect(events.first, isA<TaskRemovedEvent>());
      subscription.cancel();
    });

    test('should notify TaskMovedEvent when a task is moved', () async {
      final source =
          KanbanColumn(id: 'col1', header: 'To Do', columnLimit: null);
      final destination =
          KanbanColumn(id: 'col2', header: 'Done', columnLimit: null);
      final task = Task(id: '1', title: 'Task1', subtitle: 'Desc1');
      final events = <BoardEvent>[];
      final subscription = notifier.stream.listen((event) {
        events.add(event);
      });

      notifier.notify(TaskMovedEvent(task, source, destination));
      await Future.delayed(Duration(milliseconds: 10));

      expect(events.length, equals(1));
      expect(events.first, isA<TaskMovedEvent>());
      subscription.cancel();
    });
  });
}
