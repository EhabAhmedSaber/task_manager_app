import '../../data/models/project_model.dart';

abstract class ProjectsState {}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsSuccess extends ProjectsState {
  final List<ProjectModel> projects;
  ProjectsSuccess(this.projects);
}

class ProjectsError extends ProjectsState {
  final String message;
  ProjectsError(this.message);
}
