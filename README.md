# Clean Kanban

A flexible and customizable Kanban board package for Flutter applications, built with clean architecture principles. This package provides a complete solution for implementing Kanban-style task management in your Flutter projects.

## Features

- **Customizable Kanban Board**: Create boards with custom columns and configurations
- **Task Management**: Add, move, and update tasks across columns
- **Column Limits**: Set work-in-progress (WIP) limits for columns
- **Clean Architecture**: Follows clean architecture principles for better maintainability
- **State Management**: Built-in state management using Provider
- **Memory Storage**: Includes a memory-based storage implementation
- **Extensible**: Easy to extend with custom storage implementations

## Getting Started

### Prerequisites

- Flutter SDK ^3.6.2
- Dart SDK ^3.6.2

### Installation

Add clean_kanban to your pubspec.yaml:

```yaml
dependencies:
  clean_kanban: ^0.0.1
```

Run:

```bash
flutter pub get
```

## Usage

### Basic Setup

1. Initialize the dependency injection with your preferred repository implementation:

```dart
import 'package:clean_kanban/clean_kanban.dart';

void main() {
  // Initialize with memory repository
  setupInjection(MemoryBoardRepository());
  runApp(MyApp());
}
```

2. Set up the board provider and widget:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardProvider()..loadBoard(config: boardConfig),
      child: MaterialApp(
        home: Scaffold(
          body: BoardWidget(),
        ),
      ),
    );
  }
}
```

### Board Configuration

Define your board configuration:

```dart
final boardConfig = {
  'columns': [
    {
      'id': 'todo',
      'header': 'To Do',
      'limit': 5,
      'tasks': [
        {'id': '1', 'title': 'Task 1', 'subtitle': 'Description 1'},
      ]
    },
    {
      'id': 'doing',
      'header': 'In Progress',
      'limit': 3,
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
```

### Custom Repository Implementation

Implement your own storage solution by extending the BoardRepository interface:

```dart
class CustomBoardRepository implements BoardRepository {
  @override
  Future<Board> getBoard() async {
    // Implement board retrieval
  }

  @override
  Future<void> saveBoard(Board board) async {
    // Implement board saving
  }

  @override
  Future<void> updateBoard(Board board) async {
    // Implement board updating
  }
}
```

## Additional Information

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### License

This project is licensed under the GNU General Public License v3.0 - see the LICENSE file for details.

### Support

If you find a bug or want to request a new feature, please open an issue.
