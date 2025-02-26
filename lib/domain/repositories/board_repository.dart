import '../entities/board.dart';

abstract class BoardRepository {
  Future<Board> getBoard();
  Future<void> saveBoard(Board board);
  Future<void> updateBoard(Board board);
}
