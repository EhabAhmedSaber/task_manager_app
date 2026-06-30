import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart'; // 🌟 استيراد الـ Hive
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/project_model.dart';
import 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit() : super(ProjectsInitial());

 
  final Box _projectsBox = Hive.box('projects_box');

  void fetchProjects(String currentUserEmail) {
  
    if (currentUserEmail.trim().isEmpty) {
      emit(ProjectsSuccess(const []));
      return;
    }

    final List<ProjectModel> allProjects = _projectsBox.values
        .map((rawProject) =>
            ProjectModel.fromMap(Map<dynamic, dynamic>.from(rawProject)))
        .toList()
        .cast<ProjectModel>();

    final userProjects = allProjects.where((p) {
      final cleanCreatedBy = p.createdBy.trim().toLowerCase();
      final cleanCurrentUser = currentUserEmail.trim().toLowerCase();
      return cleanCreatedBy == cleanCurrentUser;
    }).toList();

    emit(ProjectsSuccess(List.from(userProjects)));
  }


  void addProject(String title, String description, String currentUserEmail) {
    final String projectId = DateTime.now().millisecondsSinceEpoch.toString();
    final String cleanEmail = currentUserEmail.trim().toLowerCase();

    final newProject = ProjectModel(
      id: projectId,
      title: title,
      description: description,
      status: 'Pending',
      createdBy: cleanEmail,
    );

  
    _projectsBox.put(projectId, newProject.toMap());

    fetchProjects(cleanEmail);
  }

  void updateProjectStatus(
      String projectId, String newStatus, String currentUserEmail) {
    if (_projectsBox.containsKey(projectId)) {
      final rawOldProject = _projectsBox.get(projectId);
      final oldProject =
          ProjectModel.fromMap(Map<dynamic, dynamic>.from(rawOldProject));

      final updatedProject = ProjectModel(
        id: oldProject.id,
        title: oldProject.title,
        description: oldProject.description,
        status: newStatus,
        createdBy: oldProject.createdBy, 
      );

      _projectsBox.put(projectId, updatedProject.toMap());

      final String finalEmail = currentUserEmail.trim().isNotEmpty
          ? currentUserEmail.trim().toLowerCase()
          : oldProject.createdBy.trim().toLowerCase();

      fetchProjects(finalEmail);
    }
  }

  void clearProjects() {
    emit(ProjectsInitial());
  }

  void showAddProjectBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'إضافة مشروع جديد',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'اسم المشروع'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'الوصف'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    
                    if (titleController.text.isNotEmpty) {
                     
                      final prefs = await SharedPreferences.getInstance();
                      final String secureEmail =
                          prefs.getString('user_email') ?? '';
                      addProject(
                        titleController.text,
                        descController.text,
                        secureEmail,
                      );

                      if (context.mounted) {
                        Navigator.pop(bottomSheetContext);
                      }
                    }
                  },
                  child: const Text('حفظ المشروع'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
