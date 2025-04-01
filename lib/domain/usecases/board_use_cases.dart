import 'package:clean_kanban/domain/entities/board.dart';
import 'package:clean_kanban/domain/repositories/board_repository.dart';
import 'package:clean_kanban/domain/events/event_notifier.dart';
import 'package:clean_kanban/domain/events/board_events.dart';

/// Use case for retrieving the Kanban board from storage.
///
/// Notifies listeners with a [BoardLoadedEvent] when the board is successfully loaded.
class GetBoardUseCase {
  /// The repository used to access board data.
  final BoardRepository repository;

  /// Creates a new [GetBoardUseCase] with the given [repository].
  GetBoardUseCase(this.repository);

  /// Retrieves the board from storage and notifies listeners.
  ///
  /// Returns a [Future] that completes with the loaded [Board].
  Future<Board> execute() async {
    final board = await repository.getBoard();
    EventNotifier().notify(BoardLoadedEvent(board));
    return board;
  }
}

/// Use case for saving a new Kanban board to storage.
///
/// Notifies listeners with a [BoardSavedEvent] when the board is successfully saved.
class SaveBoardUseCase {
  /// The repository used to save board data.
  final BoardRepository repository;

  /// Creates a new [SaveBoardUseCase] with the given [repository].
  SaveBoardUseCase(this.repository);

  /// Saves the given [board] to storage and notifies listeners.
  Future<void> execute(Board board) async {
    await repository.saveBoard(board);
    EventNotifier().notify(BoardSavedEvent(board));
  }
}

/// Use case for updating an existing Kanban board in storage.
///
/// Notifies listeners with a [BoardSavedEvent] when the board is successfully updated.
class UpdateBoardUseCase {
  /// The repository used to update board data.
  final BoardRepository repository;

  /// Creates a new [UpdateBoardUseCase] with the given [repository].
  UpdateBoardUseCase(this.repository);

  /// Updates the given [board] in storage and notifies listeners.
  Future<void> execute(Board board) async {
    await repository.updateBoard(board);
    EventNotifier().notify(BoardSavedEvent(board));
  }
}
