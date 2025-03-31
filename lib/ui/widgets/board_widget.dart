import 'package:clean_kanban/ui/widgets/add_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_kanban/ui/providers/board_provider.dart';
import 'package:clean_kanban/ui/widgets/column_widget.dart';
import 'package:clean_kanban/domain/entities/task.dart';
import 'package:clean_kanban/ui/theme/kanban_theme.dart';

class BoardWidget extends StatelessWidget {
  final KanbanTheme? theme;

  const BoardWidget({super.key, this.theme});
  void _showAddTaskDialog(
      BuildContext context, Function(String, String) onAddTask) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AddTaskDialog(onAdd: onAddTask));
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
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Consumer<BoardProvider>(
          builder: (context, boardProv, child) {
            if (boardProv.board == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: boardProv.board!.columns.map((column) {
                    final hasLeftColumn =
                        boardProv.board!.hasLeftColumn(column.id);
                    final hasRightColumn =
                        boardProv.board!.hasRightColumn(column.id);
                    final leftColumnId =
                        boardProv.board!.getLeftColumnId(column.id);
                    final rightColumnId =
                        boardProv.board!.getRightColumnId(column.id);
                    final isLeftColumnLimitReached = hasLeftColumn &&
                        boardProv.board!.isColumnLimitReached(leftColumnId!);
                    final isRightColumnLimitReached = hasRightColumn &&
                        boardProv.board!.isColumnLimitReached(rightColumnId!);
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: ColumnWidget(
                          theme: effectiveTheme.columnTheme,
                          column: column,
                          onAddTask: () {
                            _showAddTaskDialog(context, (title, subtitle) {
                              final newTask = Task(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                title: title,
                                subtitle: subtitle,
                              );
                              boardProv.addTask(column.id, newTask);
                            });
                          },
                          onReorderedTask: (column, oldIndex, newIndex) {
                            boardProv.reorderTask(
                                column.id, oldIndex, newIndex);
                          },
                          onTaskDropped: (source, oldIndex, destination, [destinationIndex]) {
                            boardProv.moveTask(source.id, oldIndex, destination.id, destinationIndex);
                          },
                          onMoveTaskLeftToRight:
                              boardProv.board!.hasRightColumn(column.id)
                                  ? (sourceTaskIndex) {
                                      if (rightColumnId != null) {
                                        boardProv.moveTask(column.id,
                                            sourceTaskIndex, rightColumnId);
                                      }
                                    }
                                  : null,
                          onMoveTaskRightToLeft:
                              boardProv.board!.hasLeftColumn(column.id)
                                  ? (sourceTaskIndex) {
                                      if (leftColumnId != null) {
                                        boardProv.moveTask(column.id,
                                            sourceTaskIndex, leftColumnId);
                                      }
                                    }
                                  : null,
                          canMoveLeft:
                              hasLeftColumn && !isLeftColumnLimitReached,
                          canMoveRight:
                              hasRightColumn && !isRightColumnLimitReached,
                          onClearDone: column.isDoneColumn()
                              ? () => boardProv.clearDoneColumn(column.id)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ));
          },
        ),
      ),
    );
  }
}
