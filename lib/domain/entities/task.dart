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

  Task copyWith({ String? title, String? subtitle}) {
    return Task(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Task &&
      other.id == id &&
      other.title == title &&
      other.subtitle == subtitle;
  }

  @override
  int get hashCode => Object.hash(id, title, subtitle);
}
