import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_kanban/domain/entities/column.dart';
import 'package:clean_kanban/ui/widgets/task_form_dialog.dart';
import 'package:clean_kanban/ui/providers/board_provider.dart';
import 'package:clean_kanban/ui/widgets/column_widget.dart';
import 'package:clean_kanban/domain/entities/task.dart';
import 'package:clean_kanban/ui/theme/kanban_theme.dart';

/// Constants for Board layout measurements
class BoardLayout {
  /// Border radius for the board container
  static const double boardBorderRadius = 8.0;

  /// Border width for the board container
  static const double boardBorderWidth = 1.0;

  /// Padding around the entire board
  static const double boardPadding = 4.0;

  /// Padding between columns in horizontal layout
  static const double columnHorizontalPadding = 2.0;

  /// Padding between columns in vertical layout
  static const double columnVerticalPadding = 8.0;

  /// Width threshold to determine if screen is narrow
  static const double narrowScreenThreshold = 600.0;

  /// Default maximum height for columns in mobile view
  static const double mobileColumnMaxHeight = 400.0;
}

/// A widget that handles displaying a single column within the board.
///
/// Reduces duplication between mobile and desktop layouts.
class BoardColumn extends StatelessWidget {
  /// The column to display
  final KanbanColumn column;

  /// The theme to apply to this column
  final KanbanTheme effectiveTheme;

  /// Maximum height for mobile view
  final double? mobileMaxHeight;

  /// Board provider for state management
  final BoardProvider boardProvider;

  /// Function to show task edit dialog
  final Function(BuildContext, String, String, Function(Task)) showEditTaskDialog;

  /// Function to show task add dialog
  final Function(BuildContext, Function(Task)) showAddTaskDialog;

  final Function? runTask;

  /// Creates a BoardColumn.
  const BoardColumn({
    super.key,
    required this.column,
    required this.effectiveTheme,
    required this.boardProvider,
    required this.showEditTaskDialog,
    required this.showAddTaskDialog,
    this.mobileMaxHeight,
    this.runTask,
  });

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      theme: effectiveTheme.columnTheme,
      column: column,
      mobileMaxHeight: mobileMaxHeight,
      runTask: runTask,
      onAddTask: () {
        showAddTaskDialog(context, (Task task) {
          boardProvider.addTask(column.id, task);
        });
      },
      onReorderedTask: (column, oldIndex, newIndex) {
        boardProvider.reorderTask(column.id, oldIndex, newIndex);
      },
      onTaskDropped: (source, oldIndex, destination, [destinationIndex]) {
        boardProvider.moveTask(source.id, oldIndex, destination.id, destinationIndex);
      },
      onDeleteTask: (column, index) {
        boardProvider.removeTask(column.id, index);
      },
      onEditTask: (column, index, initialTitle, initialSubtitle) => showEditTaskDialog(
        context,
        initialTitle,
        initialSubtitle,
        (Task task) {
          boardProvider.editTask(column.id, index, task);
        },
      ),
      onClearDone: column.isDoneColumn() ? () => boardProvider.clearDoneColumn(column.id) : null,
    );
  }
}

/// A widget that handles the responsive layout of the board.
///
/// Switches between vertical (mobile) and horizontal (desktop) layouts.
class BoardViewport extends StatelessWidget {
  /// The board provider for state management
  final BoardProvider boardProvider;

  /// The effective theme for styling
  final KanbanTheme effectiveTheme;

  /// Function to show task edit dialog
  final Function(BuildContext, String, String, Function(Task task)) showEditTaskDialog;

  /// Function to show task add dialog
  final Function(BuildContext, Function(Task task)) showAddTaskDialog;

  final Function? runTask;

  /// Creates a BoardViewport.
  const BoardViewport({
    super.key,
    required this.boardProvider,
    required this.effectiveTheme,
    required this.showEditTaskDialog,
    required this.showAddTaskDialog,
    this.runTask,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrowScreen = constraints.maxWidth < BoardLayout.narrowScreenThreshold;
        return Padding(
          padding: const EdgeInsets.all(BoardLayout.boardPadding),
          child: isNarrowScreen ? _buildMobileLayout(context) : _buildDesktopLayout(context),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: boardProvider.board!.columns.map((column) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: BoardLayout.columnVerticalPadding),
            child: SizedBox(
              width: double.infinity,
              child: BoardColumn(
                column: column,
                effectiveTheme: effectiveTheme,
                boardProvider: boardProvider,
                showEditTaskDialog: showEditTaskDialog,
                showAddTaskDialog: showAddTaskDialog,
                mobileMaxHeight: BoardLayout.mobileColumnMaxHeight,
                runTask: runTask,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: boardProvider.board!.columns.map((column) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: BoardLayout.columnHorizontalPadding),
            child: BoardColumn(
              column: column,
              effectiveTheme: effectiveTheme,
              boardProvider: boardProvider,
              showEditTaskDialog: showEditTaskDialog,
              showAddTaskDialog: showAddTaskDialog,
              runTask: runTask,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// A widget that displays a complete Kanban board with multiple columns.
///
/// This widget handles the visual representation of the board, including
/// column layout, task management, and theme application. It uses [BoardProvider]
/// for state management and supports customization through [KanbanTheme].
class BoardWidget extends StatelessWidget {
  /// Optional theme override for this board instance.
  ///
  /// If not provided, the theme will be obtained from the nearest [KanbanThemeProvider].
  final KanbanTheme? theme;
  final Function? runTask;

  /// Creates a [BoardWidget] with an optional theme override.
  ///
  /// The [theme] parameter allows customizing the appearance of this specific board
  /// instance without affecting other boards in the application.
  const BoardWidget({super.key, this.theme, this.runTask});

  /// Shows a dialog for adding a new task.
  ///
  /// Takes a [context] for showing the dialog and an [onAddTask] callback
  /// that receives the new task's title and subtitle.
  void _showAddTaskDialog(BuildContext context, Function(Task) onAddTask) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) =>
            TaskFormDialog(dialogTitle: 'Add New Task', submitLabel: 'Add', onSave: onAddTask));
  }

  /// Shows a dialog for editing an existing task.
  ///
  /// Takes a [context], [initialTitle], [initialSubtitle], and an [onEditTask]
  /// callback that receives the updated title and subtitle.
  void _showEditTaskDialog(
      BuildContext context, String initialTitle, String initialSubtitle, Function(Task task) onEditTask) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => TaskFormDialog(
            initialTitle: initialTitle,
            initialSubtitle: initialSubtitle,
            dialogTitle: 'Edit Task',
            submitLabel: 'Save',
            onSave: onEditTask));
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? KanbanThemeProvider.of(context);

    return KanbanThemeProvider(
      theme: effectiveTheme,
      child: Container(
        decoration: BoxDecoration(
          color: effectiveTheme.boardBackgroundColor,
          border: Border.all(
            color: effectiveTheme.boardBorderColor,
            width: BoardLayout.boardBorderWidth,
          ),
          borderRadius: BorderRadius.circular(BoardLayout.boardBorderRadius),
        ),
        child: Consumer<BoardProvider>(
          builder: (context, boardProv, child) {
            if (boardProv.board == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return BoardViewport(
              boardProvider: boardProv,
              effectiveTheme: effectiveTheme,
              showEditTaskDialog: _showEditTaskDialog,
              showAddTaskDialog: _showAddTaskDialog,
              runTask: runTask,
            );
          },
        ),
      ),
    );
  }
}
