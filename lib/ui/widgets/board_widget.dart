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
            return Expanded(
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
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
