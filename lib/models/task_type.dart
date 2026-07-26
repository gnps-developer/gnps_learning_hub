enum TaskType {
  trace,
  letterSelection,
  spelling,
  matchingPictures,
  matchingWords,
  fillInBlank,
  arrangeSentence,
}

TaskType taskTypeFromString(String value) {
  return TaskType.values.firstWhere(
        (t) => t.name == value,
    orElse: () => throw ArgumentError('Unknown task type: $value'),
  );
}