import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_kanban/injection_container.dart';
import 'package:clean_kanban/ui/providers/board_provider.dart';
import 'package:clean_kanban/ui/board_screen.dart';

void main() {
  setupInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardProvider()..loadBoard(),
      child: MaterialApp(
        title: 'Kanban Board',
        home: const BoardScreen(),
      ),
    );
  }
}
