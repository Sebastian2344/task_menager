class Task {
  int? id;
  String title;
  String? description;
  bool isCompleted; 
  DateTime deadline;
  DateTime? realisationDate;

  Task({this.id,required this.title,required this.deadline,required this.isCompleted,this.realisationDate,this.description});

  factory Task.fromJson(Map<String, Object?> object) {
  return Task(
    id: object['id'] as int?,
    title: object['title'] as String,
    deadline: DateTime.parse(object['deadline'] as String),
    realisationDate: (object['realisationDate'] != null && object['realisationDate'] != '')
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
      'isCompleted': isCompleted? 1 : 0,
    };
  }
}