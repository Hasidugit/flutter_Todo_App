import 'dart:ui';

class Task {
  String title;
  String description;
  bool isComplete;
  Color color;
  DateTime deadline; // Add a DateTime property for the deadline

  Task({
    required this.title,
    required this.description,
    this.isComplete = false,
    required this.color,
    required this.deadline, // Make deadline a required parameter
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      isComplete: map["isComplete"] ?? false,
      color: Color(map["color"]),
      deadline: DateTime.parse(map["deadline"]), // Parse deadline from string
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      "isComplete": isComplete,
      "color": color.value,
      "deadline": deadline.toIso8601String(), // Store deadline as string
    };
  }

  void updateCompletionStatus(bool newStatus) {
    isComplete = newStatus;
  }
}
