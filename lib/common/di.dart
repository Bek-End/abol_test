import 'package:abol_test/data/repositories/local_repo.dart';
import 'package:abol_test/data/repositories/task_repo.dart';
import 'package:abol_test/design/logic/bloc/task_bloc.dart';
import 'package:get_it/get_it.dart';

abstract class DI {
  static void init() {
    final getIt = GetIt.I;

    getIt
      ..registerSingleton<LocalRepo>(LocalRepository())
      ..registerSingleton<TaskRepo>(TaskRepository())
      ..registerSingleton<TaskBloc>(
          TaskBloc(taskRepository: getIt.get(), localRepository: getIt.get()));
  }

  static Future<void> dispose() async {
    return GetIt.I.reset();
  }
}
