import 'package:abol_test/data/models/task_model.dart';
import 'package:abol_test/data/repositories/local_repo.dart';
import 'package:abol_test/data/repositories/task_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required TaskRepo taskRepository,
    required LocalRepo localRepository,
  })  : _taskRepository = taskRepository,
        _localRepository = localRepository,
        super(TaskLoadingState()) {
    on<TaskInitEvent>(_getAllTasks);
    on<TaskCreateEvent>(_createTask);
    on<TaskChangeStatusEvent>(_changeStatus);
    on<TaskDeleteEvent>(_deleteTask);
  }

  final TaskRepo _taskRepository;
  final LocalRepo _localRepository;

  void _getAllTasks(TaskInitEvent event, Emitter<TaskState> emit) async {
    try {
      final tasks = await _localRepository.getAllTasks();
      emit(TaskCompleteState(tasks: tasks));
    } catch (_) {
      emit(TaskFailedState());
    }
  }

  void _createTask(TaskCreateEvent event, Emitter<TaskState> emit) async {
    try {
      final newTask = _taskRepository.createTask(event.data);
      await _localRepository.addTask(newTask);
      final newList = List<TaskModel>.from((state as TaskCompleteState).tasks)
        ..add(newTask);
      emit(TaskCompleteState(tasks: [...newList]));
    } catch (_) {
      emit(TaskFailedState());
    }
  }

  void _changeStatus(
      TaskChangeStatusEvent event, Emitter<TaskState> emit) async {
    try {
      final newTask = _taskRepository.changeStatusTask(event.task);
      await _localRepository.updateTask(newTask);
      final newList = List<TaskModel>.from((state as TaskCompleteState).tasks)
        ..remove(event.task)
        ..add(newTask);
      emit(TaskCompleteState(tasks: [...newList]));
    } catch (_) {
      emit(TaskFailedState());
    }
  }

  void _deleteTask(TaskDeleteEvent event, Emitter<TaskState> emit) async {
    try {
      await _localRepository.removeTask(event.id);
      final newList = List<TaskModel>.from((state as TaskCompleteState).tasks)
        ..removeWhere((task) => task.id == event.id);
      emit(TaskCompleteState(tasks: [...newList]));
    } catch (_) {
      emit(TaskFailedState());
    }
  }
}
