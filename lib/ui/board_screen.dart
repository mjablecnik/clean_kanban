import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_kanban/ui/providers/board_provider.dart';
import 'package:clean_kanban/domain/entities/task.dart';
import 'package:clean_kanban/ui/widgets/task_card.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kanban Board')),
      body: Consumer<BoardProvider>(
        builder: (context, boardProv, child) {
          if (boardProv.board == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Row(
            children: boardProv.board!.columns.map((column) {
              return Expanded(
                child: Column(
                  children: [
                    Text(column.header,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: column.tasks.length,
                        itemBuilder: (context, index) {
                          final task = column.tasks[index];
                          return TaskCard(
                            task: task,
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final newTask = Task(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: 'New Task',
                          subtitle: 'Task description',
                        );
                        boardProv.addTask(column.id, newTask);
                      },
                      child: const Text('Add Task'),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
