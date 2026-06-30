import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/features/projects/presentation/bloc/projects_cubit.dart';
import 'package:task_manager_app/features/projects/presentation/bloc/tasks_cubit.dart';

import '../bloc/tasks_state.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final dynamic
      project; 

  const ProjectDetailsScreen({Key? key, required this.project})
      : super(key: key);

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  String userEmail = ''; 

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    
    context
        .read<TasksCubit>()
        .fetchTasksForProject(widget.project.id.toString());
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('user_email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TasksLoaded) {
            final tasks = state.tasks;
            bool allTasksDone =
                tasks.isNotEmpty && tasks.every((task) => task.isDone);
            bool noTasksDone =
                tasks.isEmpty || tasks.every((task) => !task.isDone);

            String currentStatus;
            Color statusColor;

            if (allTasksDone) {
              currentStatus = 'Done';
              statusColor = Colors.green;
            } else if (noTasksDone) {
              currentStatus = 'Pending';
              statusColor = Colors.blue;
            } else {
              currentStatus = 'In Progress';
              statusColor = Colors.orange;
            }

            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'حالة المشروع الحالية:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: Text(
                          currentStatus,
                          key: ValueKey<String>(currentStatus),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: tasks.isEmpty
                      ? const Center(
                          child: Text('لا توجد مهام في هذا المشروع حالياً 📋'))
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return CheckboxListTile(
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              subtitle: Text('الأولوية: ${task.priority}'),
                              value: task.isDone,
                              onChanged: (bool? value) {
                                context.read<TasksCubit>().toggleTaskStatus(
                                      task.id,
                                      widget.project.id.toString(),
                                      context.read<ProjectsCubit>(),
                                      userEmail,
                                    );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<TasksCubit>().showAddTaskBottomSheet(
            context, widget.project.id.toString(), userEmail),
        child: const Icon(Icons.add),
      ),
    );
  }
}
