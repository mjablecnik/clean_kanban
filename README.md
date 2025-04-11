# Clean Kanban

A powerful, customizable Kanban board library for Flutter applications built with clean architecture principles. It provides a complete solution for implementing Kanban-style task management with features like drag-and-drop, column limits, and persistent storage.

<!-- ![Demo](docs/assets/demo.gif) -->

## Key Features

### 🎯 Core Features
- Drag and drop tasks between columns
- Long press to initiate task dragging
- Configurable column limits (WIP limits)
- Custom task card designs
- Column-specific settings (e.g., disable adding tasks)
- Clear all tasks in "Done" column
- Persistent storage support
- Responsive layout design

### 💎 UI/UX Features
- Material Design components
- Customizable themes (light/dark/custom)
- Loading states and progress indicators
- Error handling with user feedback
- Confirmation dialogs
- Mouse cursor support and tooltips
- Task editing and deletion
- Visual feedback during drag operations

### 🏗 Architecture
- Clean Architecture implementation
- Event-driven updates
- Dependency injection using GetIt
- Extensive test coverage
- Type-safe implementations

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  clean_kanban: ^0.0.1
```

## Quick Start

### 1. Initialize the Library

```dart
void main() {
  // Initialize with memory storage
  setupInjection(MemoryBoardRepository());
  runApp(MyApp());
}
```

### 2. Create a Basic Board

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardProvider()..loadBoard(),
      child: MaterialApp(
        home: Scaffold(
          body: BoardWidget(
            theme: KanbanTheme.light(),
          ),
        ),
      ),
    );
  }
}
```

### 3. Custom Board Configuration

```dart
final config = {
  'columns': [
    {
      'id': 'backlog',
      'header': 'Backlog',
      'limit': 10,
      'tasks': [
        {
          'id': '1',
          'title': 'Implement feature',
          'subtitle': 'Add new functionality'
        }
      ]
    },
    {
      'id': 'inProgress',
      'header': 'In Progress',
      'limit': 3,
      'canAddTask': false
    },
    {
      'id': 'review',
      'header': 'Review',
      'limit': 5,
      'canAddTask': false
    },
    {
      'id': 'done',
      'header': 'Done',
      'canAddTask': false
    }
  ]
};

// Load with custom config
BoardProvider()..loadBoard(config: config);
```

## Theming

### Light Theme
```dart
BoardWidget(
  theme: KanbanTheme.light(),
)
```

### Dark Theme
```dart
BoardWidget(
  theme: KanbanTheme.dark(),
)
```

### Material 3 Theme Integration (Recommended)
```dart
// This automatically adapts to your app's ThemeData
BoardWidget(
  theme: KanbanTheme.fromTheme(Theme.of(context)),
)
```

This approach is **recommended** as it:
- Ensures consistency with your app's Material 3 theme
- Automatically adapts to light/dark mode changes
- Uses the appropriate color scheme variants from your theme
- Simplifies theme management in your application

### Custom Theme
```dart
BoardWidget(
  theme: KanbanTheme(
    columnTheme: KanbanColumnTheme(
      columnBackgroundColor: Colors.grey[100],
      columnHeaderColor: Colors.blue,
      columnHeaderTextColor: Colors.white,
    ),
    cardTheme: TaskCardTheme(
      cardBackgroundColor: Colors.white,
      cardTitleColor: Colors.black87,
      cardSubtitleColor: Colors.black54,
    ),
    boardBackgroundColor: Colors.grey[200],
  ),
)
```

## Custom Storage Implementation

Implement your own storage solution:

```dart
class SharedPreferencesBoardRepository implements BoardRepository {
  static const String _boardKey = 'kanban_board';

  @override
  Future<Board> getBoard() async {
    final prefs = await SharedPreferences.getInstance();
    final boardJson = prefs.getString(_boardKey);
    if (boardJson == null) throw Exception('No board saved');
    return Board.fromConfig(jsonDecode(boardJson));
  }

  @override
  Future<void> saveBoard(Board board) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_boardKey, jsonEncode(board.toJson()));
  }

  @override
  Future<void> updateBoard(Board board) async {
    await saveBoard(board);
  }
}
```

## Event Handling

Listen to board events:

```dart
EventNotifier().subscribe((event) {
  switch (event) {
    case TaskMovedEvent moved:
      print('Task moved from ${moved.source.header} to ${moved.destination.header}');
    case TaskAddedEvent added:
      print('New task added: ${added.task.title}');
    case DoneColumnClearedEvent cleared:
      print('${cleared.removedTasks.length} tasks cleared from Done column');
  }
});
```

## Development

### Running Tests
```bash
flutter test
```

### Building Example
```bash
cd example
flutter run
```

## Requirements
- Flutter SDK ^3.6.2
- Dart SDK ^3.6.2

## Contributing
Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

## License
This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Support
- 📖 [README](README.md)
- 🐛 [Issue Tracker](https://github.com/username/clean_kanban/issues)
- 💬 [Discussions](https://github.com/username/clean_kanban/discussions)