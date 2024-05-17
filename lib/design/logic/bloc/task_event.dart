part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

final class TaskInitEvent extends TaskEvent {}

final class TaskCreateEvent extends TaskEvent {
  const TaskCreateEvent({required this.data});

  final String data;

  @override
  List<Object> get props => [...super.props, data];
}

final class TaskChangeStatusEvent extends TaskEvent {
  const TaskChangeStatusEvent(this.task);

  final TaskModel task;

  @override
  List<Object> get props => [...super.props, task];
}

final class TaskDeleteEvent extends TaskEvent {
  const TaskDeleteEvent(this.id);

  final String id;

  @override
  List<Object> get props => [...super.props, id];
}
