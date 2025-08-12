
class Task {
  /// Unique identifier for the task_manager
  String? id;

  /// Name of the task_manager
  String title;

  /// Description of the task_manager
  String subtitle;

  /// Deadline for the task_manager
  DateTime? deadline;

  /// Whether the task is solved or not
  bool solved;

  /// Priority of the task (1-4, where 4 is highest)
  int priority;

  /// When the task was created
  final DateTime created;

  /// Constructor for creating a new task_manager
  Task({
    this.id,
    required this.title,
    this.subtitle = '',
    this.deadline,
    this.solved = false,
    this.priority = 1,
    DateTime? created,
  }) :
        created = created ?? DateTime.now();

  /// Convert task_manager to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'description': subtitle,
      'deadline': deadline?.toIso8601String(),
      'solved': solved,
      'priority': priority,
      'created': created.toIso8601String(),
    };
  }

  /// Create task_manager from JSON map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String?,
      title: json['name'] as String,
      subtitle: json['description'] as String? ?? '',
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      solved: json['solved'] as bool? ?? false,
      priority: json['priority'] as int? ?? 1,
      created: json['created'] != null
          ? DateTime.parse(json['created'] as String)
          : null,
    );
  }

  /// Create a copy of this task_manager with optional new values
  Task copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? deadline,
    bool? solved,
    int? priority,
    DateTime? created,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      deadline: deadline ?? this.deadline,
      solved: solved ?? this.solved,
      priority: priority ?? this.priority,
      created: created ?? this.created,
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, name: $title, description: $subtitle, deadline: $deadline, solved: $solved, priority: $priority, created: $created}';
  }
}
