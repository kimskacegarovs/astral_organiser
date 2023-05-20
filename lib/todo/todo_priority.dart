import 'package:flutter/material.dart';

enum TodoPriority { low, mid, high }

extension TodoPriorityExtension on TodoPriority {
  static const Map<TodoPriority, String> _stringValues = {
    TodoPriority.low: 'Low',
    TodoPriority.mid: 'Mid',
    TodoPriority.high: 'High',
  };

  static final Map<TodoPriority, int> _iconCodePoints = {
    TodoPriority.low: Icons.arrow_downward.codePoint,
    TodoPriority.mid: Icons.arrow_forward.codePoint,
    TodoPriority.high: Icons.arrow_upward.codePoint,
  };

  static final Map<TodoPriority, Color> _iconColors = {
    TodoPriority.low: Colors.green,
    TodoPriority.mid: Colors.orange,
    TodoPriority.high: Colors.red,
  };

  String get stringValue => _stringValues[this] ?? '';

  IconData get iconData => IconData(
        _iconCodePoints[this] ?? Icons.error_outline.codePoint,
        fontFamily: 'MaterialIcons',
      );

  Color get iconColor => _iconColors[this] ?? Colors.grey;

  static TodoPriority fromStringValue(String? value) {
    if (value == null) return TodoPriority.low;
    return _stringValues.entries.firstWhere((element) => element.value == value).key;
  }
}
