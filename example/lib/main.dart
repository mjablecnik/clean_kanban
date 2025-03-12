import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_kanban/injection_container.dart';
import 'package:clean_kanban/ui/providers/board_provider.dart';
import 'package:clean_kanban/ui/widgets/board_widget.dart';
import 'repositories/shared_preferences_board_repository.dart'; // Updated import
import 'package:clean_kanban/ui/theme/kanban_theme.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // Add this to initialize Flutter binding
  // Initialize dependency injection with SharedPreferencesBoardRepository.
  setupInjection(SharedPreferencesBoardRepository());
  runApp(const MyExampleApp());
}

class MyExampleApp extends StatelessWidget {
  const MyExampleApp({Key? key}) : super(key: key);

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
      'limit': 5,
      'tasks': [
        {'id': '1', 'title': 'Task 1', 'subtitle': 'Description 1'},
        {'id': '2', 'title': 'Task 2', 'subtitle': 'Description 2'},
      ]
    },
    {
      'id': 'doing',
      'header': 'In Progress',
      'limit': 1,
      'tasks': [],
      'canAddTask': false
    },
    {
      'id': 'review',
      'header': 'Review',
      'limit': 2,
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
