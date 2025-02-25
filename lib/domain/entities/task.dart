class Task {
  final String id;
  final String title;
  final String subtitle;
  
  Task({required this.id, required this.title, required this.subtitle}) {
    if (title.length > 100) {
      throw ArgumentError('Title must be at most 100 characters long.');
    }
    if (subtitle.length > 100) {
      throw ArgumentError('Subtitle must be at most 100 characters long.');
    }
  }
}
