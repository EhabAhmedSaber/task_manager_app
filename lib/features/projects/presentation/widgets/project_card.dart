import 'package:flutter/material.dart';
import '../bloc/projects_cubit.dart'; // تأكد من صحة المسار حسب مشروعك
import '../bloc/tasks_cubit.dart';
import '../screens/project_details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectCard extends StatelessWidget {
  final dynamic project;
  final BuildContext blocContext;

  const ProjectCard({
    Key? key,
    required this.project,
    required this.blocContext,
    required Color statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (project.status == 'Done') {
      statusColor = Colors.green;
    } else if (project.status == 'Pending') {
      statusColor = Colors.blue;
    } else {
      statusColor = Colors.orange; // In Progress
    }
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          project.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.description),
            const SizedBox(height: 5),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: statusColor, width: 0.5),
          ),
          child: Text(
            project.status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: context.read<TasksCubit>(),
                  ),
                  BlocProvider.value(
                    value: context.read<ProjectsCubit>(),
                  ),
                ],
                child: ProjectDetailsScreen(project: project),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 350),
            ),
          );
        },
      ),
    );
  }
}
