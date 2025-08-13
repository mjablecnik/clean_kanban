import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro/screens/pomodoro_screen.dart';
import 'package:pomodoro/screens/timer_service.dart';
import 'package:provider/provider.dart';
import 'package:clean_kanban/clean_kanban.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'repositories/shared_preferences_board_repository.dart';
import 'repositories/theme_provider.dart';
import 'theme.dart';
import 'screens/column_settings_screen.dart';

class KanbanApp extends StatelessWidget {
  const KanbanApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create an instance of MaterialTheme with default TextTheme
    final materialTheme = MaterialTheme(ThemeData().textTheme);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          final boardProv = BoardProvider();
          boardProv.loadBoard(config: _boardConfig);
          boardProv.addListener(() {
            // auto save function
            if (boardProv.board != null) {
              boardProv.saveBoard();
            }
          });
          return boardProv;
        }),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<TimerService>(
          create: (_) => TimerService(soundPath: 'alarm.mp3'),
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Clean Kanban Example',
          debugShowCheckedModeBanner: false,
          theme: materialTheme.light(),
          darkTheme: materialTheme.dark(),
          themeMode: themeProvider.themeMode,
          home: const HomeScreen(),
        );
      }),
    );
  }
}

showPomodoroDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(''),
        content: SizedBox(
          width: 400,
          height: 500,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 650,
              height: 900,
              child: PomodoroScreen(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TrayListener {
  late Timer timer;
  String currentTime = "";

  @override
  void initState() {
    super.initState();

    trayManager.addListener(this);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  void onTrayIconMouseDown() async {
    //bool isVisible = await windowManager.isVisible();

    //if (isVisible) {
    //  Navigator.of(context).pop();
    //  await windowManager.hide();
    //} else {
    //  await windowManager.show();
    //  await windowManager.focus();
    //  showPomodoroDialog(context);
    //}

    await windowManager.show();
    await windowManager.focus();
    showPomodoroDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final boardProv = Provider.of<BoardProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final timerService = Provider.of<TimerService>(context);

    // Create Kanban themes that match our Material themes
    final materialTheme = MaterialTheme(Theme.of(context).textTheme);
    final kanbanLightTheme = KanbanTheme.fromTheme(materialTheme.light());
    final kanbanDarkTheme = KanbanTheme.fromTheme(materialTheme.dark());

    timerService.setCallback(() async {
      showPomodoroDialog(context);
      await windowManager.show();
      await windowManager.focus();
    });
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        final duration = timerService.currentDuration;
        trayManager.setTitle("${duration ~/ 60}:${(duration % 60).toString().split('.').first.padLeft(2, '0')}");
        setState(() {
          currentTime = "${duration ~/ 60}:${(duration % 60).toString().split('.').first.padLeft(2, '0')}";
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban Board'),
        actions: [
          Text(currentTime),
          IconButton(
            icon: Icon(timerService.timerPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              timerService.timerPlaying ? timerService.pause() : timerService.start();
            },
          ),
          // Add pomodoro button
          IconButton(
            icon: const Icon(Icons.timer),
            onPressed: () {
              showPomodoroDialog(context);
            },
          ),
          // Add save button
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (boardProv.board != null) {
                boardProv.saveBoard();
              }
            },
          ),
          // Add theme toggle button
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          // Add navigation to column settings screen
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ColumnSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BoardWidget(
        theme: themeProvider.themeMode == ThemeMode.dark ? kanbanDarkTheme : kanbanLightTheme,
        runTask: (Task task, bool isRunning) {
          print(task);
          print(isRunning);
          if (timerService.timerPlaying == isRunning) {
            timerService.timerPlaying ? timerService.pause() : timerService.start();
          }
        },
      ),
    );
  }
}

const Map<String, dynamic> _boardConfig = {
  'columns': [
    {
      'id': 'backlog',
      'header': 'Backlog',
      "headerBgColorLight": "#FFF6F6F6", // Light theme color (white-ish)
      "headerBgColorDark": "#FF333333", // Dark theme color (dark gray)
      'limit': null,
      'tasks': [
        //{'id': '1', 'title': 'Task 1', 'subtitle': 'Description 1'},
        //{'id': '2', 'title': 'Task 2', 'subtitle': 'Description 2'},
      ]
    },
    {
      'id': 'todo',
      'header': 'To Do',
      //"headerBgColorLight": "#FFF6F6F6", // Light theme color (white-ish)
      //"headerBgColorDark": "#FF333333", // Dark theme color (dark gray)
      'limit': null,
      'tasks': [
        //{'id': '1', 'title': 'Task 1', 'subtitle': 'Description 1'},
        //{'id': '2', 'title': 'Task 2', 'subtitle': 'Description 2'},
      ]
    },
    {'id': 'doing', 'header': 'In Progress', 'limit': null, 'tasks': [], 'canAddTask': false},
    {'id': 'blocked', 'header': 'Blocked', 'limit': null, 'tasks': [], 'canAddTask': false},
    {'id': 'review', 'header': 'Review', 'limit': null, 'tasks': [], 'canAddTask': false},
    {
      'id': 'done',
      'header': 'Done',
      "headerBgColorLight": "#FFA6CCA6", // Light theme color (light green)
      "headerBgColorDark": "#FF006400", // Dark theme color (dark green)
      'limit': null,
      'tasks': [],
      'canAddTask': false
    }
  ]
};
