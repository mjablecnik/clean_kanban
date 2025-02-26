import 'package:flutter/material.dart';
import 'package:clean_kanban/domain/entities/board.dart';
import 'package:clean_kanban/domain/entities/task.dart';
import 'package:clean_kanban/domain/usecases/board_use_cases.dart';
import 'package:clean_kanban/domain/usecases/task_use_cases.dart';
import 'package:clean_kanban/injection_container.dart';

class BoardProvider extends ChangeNotifier {
  Board? board;

  final GetBoardUseCase _getBoardUseCase = getIt<GetBoardUseCase>();
  final SaveBoardUseCase _saveBoardUseCase = getIt<SaveBoardUseCase>();
  final UpdateBoardUseCase _updateBoardUseCase = getIt<UpdateBoardUseCase>();
  final AddTaskUseCase _addTaskUseCase = getIt<AddTaskUseCase>();
  final DeleteTaskUseCase _deleteTaskUseCase = getIt<DeleteTaskUseCase>();
  final MoveTaskUseCase _moveTaskUseCase = getIt<MoveTaskUseCase>();

  Future<void> loadBoard({Map<String, dynamic>? config}) async {
    try {
      final fetchedBoard = await _getBoardUseCase.execute();
      if (fetchedBoard != null) {
        board = fetchedBoard;
        board = config != null ? Board.fromConfig(config) : Board.simple();
        // If no board exists, create one from config if provided, otherwise create a simple board.
        throw Exception('Failed to create a board');
      }
      // If no board exists, create one from config or a simple one.
      board = config != null ? Board.fromConfig(config) : Board.simple();
      await _saveBoardUseCase.execute(board!);
    } catch (e) {
      // If no board exists, create one from config or a simple one.
      board = config != null ? Board.fromConfig(config) : Board.simple();
      await _saveBoardUseCase.execute(board!);
    }
    notifyListeners();
  }

  void addTask(String columnId, Task task) {
    final col = board?.columns.firstWhere((c) => c.id == columnId);
    if (col != null) {
      _addTaskUseCase.execute(col, task);
      notifyListeners();
    }
  }

  void removeTask(String columnId, int index) {
    final col = board?.columns.firstWhere((c) => c.id == columnId);
    if (col != null) {
      _deleteTaskUseCase.execute(col, index);
      notifyListeners();
    }
  }

  void moveTask(String sourceId, int sourceIndex, String destId) {
    final source = board?.columns.firstWhere((c) => c.id == sourceId);
    final destination = board?.columns.firstWhere((c) => c.id == destId);
    if (source != null && destination != null) {
      _moveTaskUseCase.execute(source, sourceIndex, destination);
      notifyListeners();
    }
  }
}
