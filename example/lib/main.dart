import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_kanban/injection_container.dart';
import 'package:clean_kanban/ui/providers/board_provider.dart';
import 'package:clean_kanban/ui/board_screen.dart';

void main() {
  // Initialize dependency injection.
  setupInjection();
  runApp(const MyExampleApp());
}

class MyExampleApp extends StatelessWidget {
  const MyExampleApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardProvider()..loadBoard(),
      child: MaterialApp(
        title: 'Clean Kanban Example',
        home: const BoardScreen(),
      ),
    );
  }
}
