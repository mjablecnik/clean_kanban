import 'package:clean_kanban/domain/events/board_events.dart';
import 'package:clean_kanban/domain/events/event_notifier.dart';
import 'package:clean_kanban/injection_container.dart';
import 'package:example/kanban_app.dart';
import 'package:example/repositories/shared_preferences_board_repository.dart';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window manager
  await windowManager.ensureInitialized();
  await windowManager.setPreventClose(false);
  WindowOptions windowOptions = WindowOptions(
    //size: Size(800, 600),
    //center: true,
    skipTaskbar: true,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: true,
    //backgroundColor: MacosColors.transparent,
    alwaysOnTop: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Initialize Kanban App
  setupInjection(SharedPreferencesBoardRepository());
  EventNotifier().subscribe((event) {
    switch (event) {
      case BoardLoadedEvent loaded:
        debugPrint('Board loaded: ${loaded.board}');
      case BoardSavedEvent saved:
        debugPrint('Board saved: ${saved.board}');
      case TaskMovedEvent moved:
        debugPrint('Task "${moved.task.title}" moved from ${moved.source.header} to ${moved.destination.header}');
      case TaskAddedEvent added:
        debugPrint('New task added: "${added.task.title}"');
      case TaskRemovedEvent removed:
        debugPrint('Task removed: "${removed.task.title}"');
      case TaskEditedEvent edited:
        debugPrint('Task edited: title="${edited.newTask.title}"');
      case TaskReorderedEvent reordered:
        debugPrint(
            'Task reordered: "${reordered.task.title}" moved from ${reordered.oldIndex} to ${reordered.newIndex} in ${reordered.column.header}');
      case DoneColumnClearedEvent cleared:
        debugPrint('${cleared.removedTasks.length} tasks cleared from Done column');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TrayListener {
  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
    _initTray();
  }

  Future<void> _initTray() async {
    await trayManager.setIcon('assets/pomodoro-icon.png', iconSize: 22);
    await trayManager.setTitle('Kanban Manager');
    await trayManager.setContextMenu(
      Menu(items: [MenuItem(key: 'show', label: 'Show'), MenuItem.separator(), MenuItem(key: 'exit', label: 'Exit')]),
    );
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  //@override
  //void onTrayIconMouseDown() async {
  //  // bool isVisible = await windowManager.isVisible();

  //  // if (isVisible) {
  //  //   await windowManager.hide();
  //  // } else {
  //  //   await windowManager.show();
  //  //   await windowManager.focus();
  //  // }

  //  await windowManager.show();
  //  await windowManager.focus();
  //}

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show':
        windowManager.show();
        break;
      case 'exit':
        windowManager.close();
        break;
    }
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: KanbanApp());
  }
}
