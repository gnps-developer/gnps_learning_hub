import 'task.dart';

class LessonSection {
  final String id;
  final String title;
  final List<Task> tasks;

  const LessonSection({
    required this.id,
    required this.title,
    required this.tasks,
  });

  factory LessonSection.fromJson(Map<String, dynamic> json) {
    final rawTasks = (json['tasks'] as List?) ?? [];
    return LessonSection(
      id: json['id'] as String,
      title: json['title'] as String,
      tasks: rawTasks
          .map((t) => Task.fromJson(Map<String, dynamic>.from(t as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'tasks': tasks.map((t) => t.toJson()).toList(),
  };
}

class Lesson {
  final String id;
  final String title;
  final int order;
  final List<LessonSection> sections;

  /// When true, chapters/sections within this lesson are presented in a
  /// random order during a learning session.
  final bool shuffleSections;

  /// When true, tasks within each chapter are presented in a random order.
  final bool shuffleTasks;

  /// When false, this lesson is excluded from `Journey.activeLessons` —
  /// hidden from the journey map entirely, as if it doesn't exist yet.
  /// Defaults to true.
  final bool visible;

  const Lesson({
    required this.id,
    required this.title,
    required this.order,
    required this.sections,
    this.shuffleSections = false,
    this.shuffleTasks = false,
    this.visible = true,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    final rawSections = (json['sections'] as List?) ?? [];
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      order: (json['order'] as num).toInt(),
      sections: rawSections
          .map((s) => LessonSection.fromJson(Map<String, dynamic>.from(s as Map)))
          .toList(),
      shuffleSections: json['shuffleSections'] as bool? ?? false,
      shuffleTasks: json['shuffleTasks'] as bool? ?? false,
      visible: json['visible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'order': order,
    'sections': sections.map((s) => s.toJson()).toList(),
    'shuffleSections': shuffleSections,
    'shuffleTasks': shuffleTasks,
    'visible': visible,
  };

  /// Helper to get all tasks across all sections in order.
  List<Task> get allTasks => sections.expand((s) => s.tasks).toList();
}
