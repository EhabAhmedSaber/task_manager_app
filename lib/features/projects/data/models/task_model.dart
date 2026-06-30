class TaskModel {
  final String id;
  final String projectId;
  final String title;
  final String priority;
  bool isDone; // تأكد إنها متغيرة (ليس final) عشان نقدر نقلبها في الـ Checkbox

  TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.priority,
    this.isDone = false,
  });

  // 1️⃣ الدالة الأولى: تحويل الـ Object إلى Map ليتم تخزينه في الـ Hive
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'title': title,
      'priority': priority,
      'isDone': isDone,
    };
  }

  // 2️⃣ الدالة الثانية: استقبال البيانات من الـ Hive وتحويلها لـ Object فلاتر
  factory TaskModel.fromMap(Map<dynamic, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      projectId: map['projectId'] ?? '',
      title: map['title'] ?? '',
      priority: map['priority'] ?? 'Medium',
      isDone: map['isDone'] ?? false,
    );
  }
}
