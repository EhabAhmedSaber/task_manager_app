class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String createdBy;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdBy,
  });

  // 🌟 1. الدالة المنقذة اللي الـ Cubit بيدور عليها عشان يقرا من الـ Hive
  factory ProjectModel.fromMap(Map<dynamic, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'Pending',
      createdBy: map['createdBy'] ?? '',
    );
  }

  // 🌟 2. الدالة اللي بنستخدمها عشان نحول الكائن لـ Map ونخزنه جوه الـ Hive
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdBy': createdBy,
    };
  }
}
