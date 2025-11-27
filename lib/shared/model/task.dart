class Task {
  int? id;
  String title;
  String? description;
  bool isCompleted;
  DateTime deadline;
  DateTime? realisationDate;

  Task({
    this.id,
    required this.title,
    required this.deadline,
    required this.isCompleted,
    this.realisationDate,
    this.description,
  });

  factory Task.fromJson(Map<String, Object?> object) {
    return Task(
      id: object['id'] as int?,
      title: object['title'] as String,
      deadline: DateTime.parse(object['deadline'] as String),
      realisationDate:
          (object['realisationDate'] != null && object['realisationDate'] != '')
          ? DateTime.parse(object['realisationDate'] as String)
          : null,
      isCompleted: object['isCompleted'] is int
          ? (object['isCompleted'] as int) == 1
          : object['isCompleted'] == true,
      description: object['description'] as String? ?? '',
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description ?? '',
      'deadline': deadline.toIso8601String(),
      'realisationDate': realisationDate?.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          isCompleted == other.isCompleted &&
          deadline == other.deadline &&
          realisationDate == other.realisationDate;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      isCompleted.hashCode ^
      deadline.hashCode ^
      realisationDate.hashCode;
}
