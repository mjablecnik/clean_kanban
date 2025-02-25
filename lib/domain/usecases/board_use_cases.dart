import '../entities/board.dart';
import '../repositories/board_repository.dart';

class GetBoardUseCase {
  final BoardRepository repository;
  GetBoardUseCase(this.repository);

  Future<Board> execute() async {
    return await repository.getBoard();
  }
}

class SaveBoardUseCase {
  final BoardRepository repository;
  SaveBoardUseCase(this.repository);

  Future<void> execute(Board board) async {
    await repository.saveBoard(board);
  }
}

class UpdateBoardUseCase {
  final BoardRepository repository;
  UpdateBoardUseCase(this.repository);

  Future<void> execute(Board board) async {
    await repository.updateBoard(board);
  }
}
