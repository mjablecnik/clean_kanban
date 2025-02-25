import '../entities/board.dart';
import '../repositories/board_repository.dart';
import '../events/event_notifier.dart';
import '../events/board_events.dart';

class GetBoardUseCase {
  final BoardRepository repository;
  GetBoardUseCase(this.repository);

  Future<Board> execute() async {
    final board = await repository.getBoard();
    EventNotifier().notify(BoardLoadedEvent(board));
    return board;
  }
}

class SaveBoardUseCase {
  final BoardRepository repository;
  SaveBoardUseCase(this.repository);

  Future<void> execute(Board board) async {
    await repository.saveBoard(board);
    EventNotifier().notify(BoardSavedEvent(board));
  }
}

class UpdateBoardUseCase {
  final BoardRepository repository;
  UpdateBoardUseCase(this.repository);

  Future<void> execute(Board board) async {
    await repository.updateBoard(board);
    EventNotifier().notify(BoardSavedEvent(board));
  }
}
