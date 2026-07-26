import 'task_type.dart';

export 'task_type.dart';

/// A single learning activity within a lesson.
///
/// `content` shape depends on `type`:
/// - trace:            { letter, transliteration }
/// - spelling:         { imageUrl, targetWord, letterBank: [...] }
/// - matchingPictures: { word, correctImageUrl, distractorImageUrls: [...] }
/// - arrangeSentence:  { words: [...], correctOrder: [...] }
/// - fillInBlank:      { sentenceParts: [...], correctWord, options: [...] }
class Task {
  final String id;
  final TaskType type;
  final int pointsAwarded;
  final Map<String, dynamic> content;

  const Task({
    required this.id,
    required this.type,
    required this.pointsAwarded,
    required this.content,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      type: taskTypeFromString(json['type'] as String),
      pointsAwarded: (json['pointsAwarded'] as num?)?.toInt() ?? 10,
      content: Map<String, dynamic>.from(json['content'] as Map),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'pointsAwarded': pointsAwarded,
    'content': content,
  };
}
