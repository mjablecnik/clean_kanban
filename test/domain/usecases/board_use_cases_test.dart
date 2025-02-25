import 'package:flutter_test/flutter_test.dart';
import 'package:clean_kanban/domain/entities/board.dart';
import 'package:clean_kanban/domain/repositories/board_repository.dart';
import 'package:clean_kanban/domain/usecases/board_use_cases.dart';

void main() {
  late InMemoryBoardRepository repository;
  late GetBoardUseCase getBoardUseCase;
  late SaveBoardUseCase saveBoardUseCase;
  late UpdateBoardUseCase updateBoardUseCase;

  setUp(() {
    repository = InMemoryBoardRepository();
    getBoardUseCase = GetBoardUseCase(repository);
    saveBoardUseCase = SaveBoardUseCase(repository);
    updateBoardUseCase = UpdateBoardUseCase(repository);
  });

  test('should throw error when getting board if none saved', () async {
    expect(() => getBoardUseCase.execute(), throwsA(isA<Exception>()));
  });

  test('should save and retrieve a board', () async {
    final board = Board.simple();
    await saveBoardUseCase.execute(board);
    final retrieved = await getBoardUseCase.execute();
    expect(retrieved, equals(board));
  });

  test('should update the board', () async {
    final boardA = Board.simple();
    await saveBoardUseCase.execute(boardA);
    final boardB = Board(columns: [...boardA.columns]);
    await updateBoardUseCase.execute(boardB);
    final updated = await getBoardUseCase.execute();
    expect(updated, equals(boardB));
  });
}
