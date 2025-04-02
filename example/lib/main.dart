import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_kanban/clean_kanban.dart';
import 'repositories/shared_preferences_board_repository.dart'; // Updated import

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // Add this to initialize Flutter binding
  // Initialize dependency injection with SharedPreferencesBoardRepository.
  setupInjection(SharedPreferencesBoardRepository());
  EventNotifier().subscribe((event) {
    switch (event) {
      case BoardLoadedEvent loaded:
        print('Board loaded: ${loaded.board}');
      case BoardSavedEvent saved:
        print('Board saved: ${saved.board}');
      case TaskMovedEvent moved:
        print('Task "${moved.task.title}" moved from ${moved.source.header} to ${moved.destination.header}');
      case TaskAddedEvent added:
        print('New task added: "${added.task.title}"');
      case TaskRemovedEvent removed:
        print('Task removed: "${removed.task.title}"');
      case TaskEditedEvent edited:
        print('Task edited: title="${edited.newTask.title}"');
      case TaskReorderedEvent reordered:
        print('Task reordered: "${reordered.task.title}" moved from ${reordered.oldIndex} to ${reordered.newIndex} in ${reordered.column.header}');
      case DoneColumnClearedEvent cleared:
        print('${cleared.removedTasks.length} tasks cleared from Done column');
    }
});
  runApp(const MyExampleApp());
}

class MyExampleApp extends StatelessWidget {
  const MyExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) {
      final boardProv = BoardProvider();
      boardProv.loadBoard(config: _boardConfig);
      boardProv.addListener(() {
        // auto save function
        if (boardProv.board != null) {
          boardProv.saveBoard();
        }
      });
      return boardProv;
    }, child: Consumer<BoardProvider>(builder: (context, boardProv, child) {
      return MaterialApp(
        title: 'Clean Kanban Example',
        theme: ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Kanban Board'),
            actions: [
              // Add save button
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  if (boardProv.board != null) {
                    boardProv.saveBoard();
                  }
                },
              ),
            ],
          ),
          body: BoardWidget(
            theme: KanbanTheme.light(),
          ),
        ),
      );
    }));
  }
}

const Map<String, dynamic> _boardConfig = {
  'columns': [
    {
      'id': 'todo',
      'header': 'To Do',
      'limit': 15,
      'tasks': [
        {'id': '1', 'title': 'Task 1', 'subtitle': 'Description 1'},
        {'id': '2', 'title': 'Task 2', 'subtitle': 'Description 2'},
      ]
    },
    {
      'id': 'doing',
      'header': 'In Progress',
      'limit': null,
      'tasks': [],
      'canAddTask': false
    },
    {
      'id': 'review',
      'header': 'Review',
      'limit': null,
      'tasks': [],
      'canAddTask': false
    },
    {
      'id': 'done',
      'header': 'Done',
      'limit': null,
      'tasks': [],
      'canAddTask': false
    }
  ]
};
