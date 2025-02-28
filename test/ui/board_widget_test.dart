import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:clean_kanban/ui/widgets/board_widget.dart';
import 'package:clean_kanban/ui/providers/board_provider.dart';
import 'package:clean_kanban/injection_container.dart';
import 'package:clean_kanban/domain/entities/board.dart';
import '../domain/repositories/test_board_repository.dart';

void main() {
  setUpAll(() async {
    // Reset and setup injection so dependencies are registered.
    await getIt.reset();
    setupInjection(TestBoardRepository());
  });

  testWidgets('BoardWidget shows loading indicator then board UI',
      (WidgetTester tester) async {
    // Arrange: Create a BoardProvider that initially has a null board.
    final boardProvider = BoardProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<BoardProvider>.value(
        value: boardProvider,
        child: const MaterialApp(home: BoardWidget()),
      ),
    );

    // Assert: Should show a loading indicator while board is null.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Act: Simulate board load by assigning a simple board and notifying listeners.
    boardProvider.board =
        boardProvider.board ?? BoardProvider().board ?? Board.simple();
    boardProvider.notifyListeners();
    await tester.pumpAndSettle();

    // Assert: Now we expect the columns to be visible.
    expect(find.text('To Do'), findsOneWidget);
    expect(find.text('Doing'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
  });
}
