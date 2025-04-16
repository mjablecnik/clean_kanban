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
  ///
  /// Uses a white-based color scheme with blue accents.
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
  ///
  /// Uses a dark color scheme with appropriate contrast for better visibility.
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
  ///
  /// Takes a [primaryColor] parameter and generates appropriate light and dark
  /// variants for various theme components.
  /// @deprecated Use [fromTheme] instead. This will be removed in a future version.
  @Deprecated('Use fromTheme instead. This will be removed in a future version.')
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

  /// Creates a [KanbanTheme] based on the provided [ThemeData].
  ///
  /// Uses colors from the theme's color scheme to ensure consistency with the app theme.
  factory KanbanTheme.fromTheme(ThemeData theme) {
    final ColorScheme colorScheme = theme.colorScheme;
    
    return KanbanTheme(
      columnTheme: KanbanColumnTheme(
        columnBackgroundColor: colorScheme.surfaceContainerLow,
        columnBorderColor: colorScheme.outlineVariant,
        columnHeaderColor: colorScheme.primaryContainer,
        columnHeaderTextColor: colorScheme.onPrimaryContainer,
        columnAddButtonBoxColor: colorScheme.primary,
        columnAddIconColor: colorScheme.onPrimary,
      ),
      cardTheme: TaskCardTheme(
        cardBackgroundColor: colorScheme.surfaceContainerLowest,
        cardBorderColor: colorScheme.outlineVariant,
        cardTitleColor: colorScheme.onSurface,
        cardSubtitleColor: colorScheme.onSurfaceVariant,
        cardMoveIconEnabledColor: colorScheme.primary,
        cardMoveIconDisabledColor: colorScheme.outlineVariant,
      ),
      boardBackgroundColor: colorScheme.surface,
      boardBorderColor: colorScheme.outline,
    );
  }

  /// Creates a copy of this theme with the given fields replaced with new values.
  ///
  /// Any parameter that is null will keep its original value.
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

/// An inherited widget that provides theme access to its descendants.
///
/// Wraps a widget subtree and makes a [KanbanTheme] available to all descendants
/// through the [of] method.
class KanbanThemeProvider extends InheritedWidget {
  /// The theme to be provided to descendants.
  final KanbanTheme theme;

  /// Creates a [KanbanThemeProvider] that provides the given theme to its descendants.
  ///
  /// The [theme] and [child] arguments must not be null.
  const KanbanThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  /// Retrieves the [KanbanTheme] from the closest [KanbanThemeProvider] ancestor.
  ///
  /// If there is no [KanbanThemeProvider] in the widget's ancestry, returns a theme
  /// based on the current system theme. This method will cause the widget to rebuild 
  /// when the theme changes.
  static KanbanTheme of(BuildContext context) {
    final KanbanThemeProvider? provider =
        context.dependOnInheritedWidgetOfExactType<KanbanThemeProvider>();
    return provider?.theme ?? KanbanTheme.fromTheme(Theme.of(context));
  }

  /// Determines whether dependent widgets should rebuild when the theme changes.
  @override
  bool updateShouldNotify(KanbanThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}
