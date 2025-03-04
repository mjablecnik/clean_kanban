import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_kanban/ui/providers/board_provider.dart';
import 'package:clean_kanban/ui/widgets/column_widget.dart';
import 'package:clean_kanban/domain/entities/task.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardProvider>(
      builder: (context, boardProv, child) {
        if (boardProv.board == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Row(
          children: boardProv.board!.columns.map((column) {
            final hasLeftColumn = boardProv.board!.hasLeftColumn(column.id);
            final hasRightColumn = boardProv.board!.hasRightColumn(column.id);
            final leftColumnId = boardProv.board!.getLeftColumnId(column.id);
            final rightColumnId = boardProv.board!.getRightColumnId(column.id);
            final isLeftColumnLimitReached = hasLeftColumn &&
                boardProv.board!.isColumnLimitReached(leftColumnId!);
            final isRightColumnLimitReached = hasRightColumn &&
                boardProv.board!.isColumnLimitReached(rightColumnId!);
            return Expanded(
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0), 
              child: ColumnWidget(
                  column: column,
                  onAddTask: (title, subtitle) {
                    final newTask = Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: title,
                      subtitle: subtitle,
                    );
                    boardProv.addTask(column.id, newTask);
                  },
                  onReorderedTask: (column, oldIndex, newIndex) {
                    boardProv.reorderTask(column.id, oldIndex, newIndex);
                  },
                  onMoveTaskLeftToRight:
                      boardProv.board!.hasRightColumn(column.id)
                          ? (sourceTaskIndex) {
                              if (rightColumnId != null) {
                                boardProv.moveTask(
                                    column.id, sourceTaskIndex, rightColumnId!);
                              }
                            }
                          : null,
                  onMoveTaskRightToLeft: boardProv.board!.hasLeftColumn(column.id)
                      ? (sourceTaskIndex) {
                          if (leftColumnId != null) {
                            boardProv.moveTask(
                                column.id, sourceTaskIndex, leftColumnId);
                          }
                        }
                      : null,
                  canMoveLeft: hasLeftColumn && !isLeftColumnLimitReached,
                  canMoveRight: hasRightColumn && !isRightColumnLimitReached,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
