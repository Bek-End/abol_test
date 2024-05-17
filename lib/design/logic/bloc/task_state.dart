part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TaskLoadingState extends TaskState {}

final class TaskFailedState extends TaskState {}

final class TaskCompleteState extends TaskState {
  const TaskCompleteState({required this.tasks});

  final List<TaskModel> tasks;

  @override
  List<Object> get props => [...super.props, tasks];
}
