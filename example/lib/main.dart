import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_kanban/injection_container.dart';
import 'package:clean_kanban/ui/providers/board_provider.dart';
import 'package:clean_kanban/ui/widgets/board_widget.dart';
import 'repositories/memory_board_repository.dart';

void main() {
  // Initialize dependency injection with MemoryBoardRepository.
  setupInjection(MemoryBoardRepository());
  runApp(const MyExampleApp());
}

class MyExampleApp extends StatelessWidget {
  const MyExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardProvider()..loadBoard(config: _boardConfig),
      child: MaterialApp(
        title: 'Clean Kanban Example',
        theme: ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Kanban Board'),
          ),
          body: const BoardWidget(),
        ),
      ),
    );
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
