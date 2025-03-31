import '../../core/exceptions.dart';

class Task {
  final String id;
  final String title;
  final String subtitle;
  
  Task({required this.id, required this.title, required this.subtitle}) {
    if (title.length > 100) {
      throw TaskOperationException('Title must be at most 100 characters long.');
    }
    if (subtitle.length > 100) {
      throw TaskOperationException('Subtitle must be at most 100 characters long.');
    }
  }
  
  // Convert task to JSON format for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
    };
  }
}
