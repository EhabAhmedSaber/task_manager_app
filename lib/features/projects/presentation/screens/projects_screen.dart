// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../bloc/projects_cubit.dart';
import '../bloc/projects_state.dart';
import '../widgets/project_card.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserEmailAndFetch();
  }

  Future<void> _loadUserEmailAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email') ?? '';
    setState(() {
      userEmail = email;
    });
    if (mounted && email.isNotEmpty) {
      context.read<ProjectsCubit>().fetchProjects(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المشاريع الحالية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          )
        ],
      ),
      body: BlocBuilder<ProjectsCubit, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProjectsSuccess) {
            final activeProjects = state.projects;

            if (activeProjects.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد مشاريع حالياً 📋\nاضغط على الزر بالأسفل لإضافة مشروع',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: activeProjects.length,
              itemBuilder: (context, index) {
                final project = activeProjects[index];
                Color statusColor;
                if (project.status == 'Done') {
                  statusColor = Colors.green;
                } else if (project.status == 'Pending') {
                  statusColor = Colors.blue;
                } else {
                  statusColor = Colors.orange; // In Progress
                }

                return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: ProjectCard(
                      project: project,
                      statusColor: statusColor,
                      blocContext: context,
                    ));
              },
            );
          } else if (state is ProjectsError) {
            return const Center(child: Text('حدث خطأ أثناء جلب المشاريع ❌'));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<ProjectsCubit>().showAddProjectBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
