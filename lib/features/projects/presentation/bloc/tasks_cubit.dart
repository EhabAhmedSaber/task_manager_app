import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_manager_app/features/projects/presentation/bloc/projects_cubit.dart';
import '../../data/models/task_model.dart'; 
import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  final Box _tasksBox = Hive.box('tasks_box');

  void fetchTasksForProject(String projectId) {
    emit(TasksLoading());

    final List<TaskModel> allTasks = _tasksBox.values
        .map(
            (rawTask) => TaskModel.fromMap(Map<dynamic, dynamic>.from(rawTask)))
        .toList()
        .cast<TaskModel>();
    final projectTasks =
        allTasks.where((task) => task.projectId == projectId).toList();

    emit(TasksLoaded(projectTasks));
  }
  void addTask(String title, String priority, String projectId) {
    final String taskId = DateTime.now().millisecondsSinceEpoch.toString();

    final newTask = TaskModel(
      id: taskId,
      projectId: projectId,
      title: title,
      priority: priority,
      isDone: false,
    );
    _tasksBox.put(taskId, newTask.toMap());
    fetchTasksForProject(projectId);
  }
  void toggleTaskStatus(String taskId, String projectId,
      ProjectsCubit projectsCubit, String currentUserEmail) {
   
    if (_tasksBox.containsKey(taskId)) {
      final rawOldTask = _tasksBox.get(taskId);
      final oldTask = TaskModel.fromMap(Map<dynamic, dynamic>.from(rawOldTask));
      final updatedTask = TaskModel(
        id: oldTask.id,
        projectId: oldTask.projectId,
        title: oldTask.title,
        priority: oldTask.priority,
        isDone: !oldTask.isDone, 
      );

      _tasksBox.put(taskId, updatedTask.toMap());
      final List<TaskModel> allTasks = _tasksBox.values
          .map((rawTask) =>
              TaskModel.fromMap(Map<dynamic, dynamic>.from(rawTask)))
          .toList()
          .cast<TaskModel>();

      final currentTasks =
          allTasks.where((task) => task.projectId == projectId).toList();
      bool allTasksDone =
          currentTasks.isNotEmpty && currentTasks.every((task) => task.isDone);

      bool noTasksDone =
          currentTasks.isEmpty || currentTasks.every((task) => !task.isDone);

      String calculatedStatus;
      if (allTasksDone) {
        calculatedStatus = 'Done';
      } else if (noTasksDone) {
        calculatedStatus = 'Pending';
      } else {
        calculatedStatus = 'In Progress';
      }
      projectsCubit.updateProjectStatus(
          projectId, calculatedStatus, currentUserEmail);

      emit(TasksLoaded(currentTasks));
    }
  }
  void showAddTaskBottomSheet(
      BuildContext context, String projectId, String userEmail) {
    final taskController = TextEditingController();
    String selectedPriority = 'Medium';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'إضافة مهمة جديدة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  labelText: 'اسم المهمة',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) selectedPriority = value;
                },
                decoration: const InputDecoration(
                  labelText: 'الأولوية',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      addTask(
                        taskController.text,
                        selectedPriority,
                        projectId,
                      );
                      Navigator.pop(bottomSheetContext);
                    }
                  },
                  child: const Text('حفظ المهمة'),
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
