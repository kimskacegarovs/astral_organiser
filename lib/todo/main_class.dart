import 'dart:convert';
import './todo_priority.dart';

class Todo {
  final String title;
  final String description;
  bool isCompleted;
  TodoPriority priority = TodoPriority.low;
  DateTime? createdAt;
  DateTime? modifiedAt;

  Todo({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
    this.modifiedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.stringValue,
      'createdAt': createdAt?.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
    };
  }



  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      priority: TodoPriorityExtension.fromStringValue(map['priority']),
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      modifiedAt:
          map['modifiedAt'] != null ? DateTime.parse(map['modifiedAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));
}
