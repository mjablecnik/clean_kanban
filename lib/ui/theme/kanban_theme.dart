import 'package:flutter/material.dart';
import 'package:clean_kanban/ui/widgets/column_widget.dart';
import 'package:clean_kanban/ui/widgets/task_card.dart';

/// A comprehensive theme for the Kanban board.
///
/// This class coordinates all component themes (columns, cards, board, dialog)
/// and provides consistent styling across the entire board.
class KanbanTheme {
  /// The theme for the columns in the Kanban board.
  final KanbanColumnTheme columnTheme;

  /// The theme for the task cards in the Kanban board.
  final TaskCardTheme cardTheme;

  /// The background color of the board.
  final Color boardBackgroundColor;

  /// The color of the board's border.
  final Color boardBorderColor;

  /// Creates a [KanbanTheme] with default values.
  const KanbanTheme({
    this.columnTheme = const KanbanColumnTheme(),
    this.cardTheme = const TaskCardTheme(),
    this.boardBackgroundColor = const Color(0xFFF5F5F5),
    this.boardBorderColor = const Color(0xFFE0E0E0),
// TODO: add dialog theme
  });

  /// Creates a light theme for the Kanban board.
  factory KanbanTheme.light() {
    return const KanbanTheme(
      columnTheme: KanbanColumnTheme(
        columnBackgroundColor: Colors.white,
        columnBorderColor: Color(0xFFE0E0E0),
        columnHeaderColor: Colors.blue,
        columnHeaderTextColor: Colors.black87,
        columnAddButtonBoxColor: Color.fromARGB(255, 76, 127, 175),
        columnAddIconColor: Colors.white,
      ),
      cardTheme: TaskCardTheme(
        cardBackgroundColor: Colors.white,
        cardBorderColor: Color(0xFFE0E0E0),
        cardTitleColor: Color.fromRGBO(0, 0, 0, 0.867),
        cardSubtitleColor: Color.fromRGBO(0, 0, 0, 0.541),
        cardMoveIconEnabledColor: Color.fromRGBO(25, 118, 210, 1),
        cardMoveIconDisabledColor: Color.fromRGBO(224, 224, 224, 1),
      ),
      boardBackgroundColor: Color(0xFFF5F5F5),
      boardBorderColor: Color(0xFFE0E0E0),
    );
  }

  /// Creates a dark theme for the Kanban board.
  factory KanbanTheme.dark() {
    return const KanbanTheme(
      columnTheme: KanbanColumnTheme(
        columnBackgroundColor: Color(0xFF2D2D2D),
        columnBorderColor: Color(0xFF3D3D3D),
        columnHeaderColor: Color(0xFF1E1E1E),
        columnHeaderTextColor: Colors.white,
        columnAddButtonBoxColor: Color(0xFF0D47A1),
        columnAddIconColor: Colors.white,
      ),
      cardTheme: TaskCardTheme(
        cardBackgroundColor: Color(0xFF424242),
        cardBorderColor: Color(0xFF616161),
        cardTitleColor: Colors.white,
        cardSubtitleColor: Color.fromRGBO(255, 255, 255, 0.7),
        cardMoveIconEnabledColor: Color(0xFF90CAF9),
        cardMoveIconDisabledColor: Color(0xFF616161),
      ),
      boardBackgroundColor: Color(0xFF121212),
      boardBorderColor: Color(0xFF1E1E1E),
    );
  }

  /// Creates a custom theme based on the primary color.
  factory KanbanTheme.fromColor(Color primaryColor) {
    final Color primaryLight = Color.lerp(primaryColor, Colors.white, 0.3)!;
    final Color primaryDark = Color.lerp(primaryColor, Colors.black, 0.3)!;

    return KanbanTheme(
      columnTheme: KanbanColumnTheme(
        columnBackgroundColor: Colors.white,
        columnBorderColor: const Color(0xFFE0E0E0),
        columnHeaderColor: primaryColor,
        columnHeaderTextColor: Colors.white,
        columnAddButtonBoxColor: primaryDark,
        columnAddIconColor: Colors.white,
      ),
      cardTheme: const TaskCardTheme(
        cardBackgroundColor: Colors.white,
        cardBorderColor: Color(0xFFE0E0E0),
        cardTitleColor: Color.fromRGBO(0, 0, 0, 0.867),
        cardSubtitleColor: Color.fromRGBO(0, 0, 0, 0.541),
        cardMoveIconEnabledColor: Color.fromRGBO(25, 118, 210, 1),
        cardMoveIconDisabledColor: Color.fromRGBO(224, 224, 224, 1),
      ),
      boardBackgroundColor: const Color(0xFFF5F5F5),
      boardBorderColor: const Color(0xFFE0E0E0),
    );
  }

  /// Creates a copy of this theme with the given fields replaced with new values.
  KanbanTheme copyWith({
    KanbanColumnTheme? columnTheme,
    TaskCardTheme? cardTheme,
    Color? boardBackgroundColor,
    Color? boardBorderColor,
    Color? dialogBackgroundColor,
    Color? dialogTextFieldColor,
    Color? dialogPrimaryButtonColor,
    Color? dialogPrimaryButtonTextColor,
    Color? dialogSecondaryButtonColor,
    Color? dialogSecondaryButtonTextColor,
  }) {
    return KanbanTheme(
      columnTheme: columnTheme ?? this.columnTheme,
      cardTheme: cardTheme ?? this.cardTheme,
      boardBackgroundColor: boardBackgroundColor ?? this.boardBackgroundColor,
      boardBorderColor: boardBorderColor ?? this.boardBorderColor,
    );
  }
}

/// Extension to provide theme access through BuildContext.
class KanbanThemeProvider extends InheritedWidget {
  final KanbanTheme theme;

  const KanbanThemeProvider({
    Key? key,
    required this.theme,
    required Widget child,
  }) : super(key: key, child: child);

// TODO: is this the correct way to implement this?
  static KanbanTheme of(BuildContext context) {
    final KanbanThemeProvider? provider =
        context.dependOnInheritedWidgetOfExactType<KanbanThemeProvider>();
    return provider?.theme ?? const KanbanTheme();
  }

  @override
  bool updateShouldNotify(KanbanThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}
