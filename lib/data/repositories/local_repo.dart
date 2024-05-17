import 'package:abol_test/data/models/task_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

abstract class LocalRepo {
  Future<List<TaskModel>> getAllTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel newTask);
  Future<void> removeTask(String id);
}

class LocalRepository implements LocalRepo {
  static final LocalRepository _instance = LocalRepository._();
  factory LocalRepository() => _instance;
  LocalRepository._();

  static Future<void> init() async {
    final appDocsDir = await getApplicationDocumentsDirectory();
    Hive
      ..init(appDocsDir.path)
      ..registerAdapter(TaskModelAdapter());
  }

  @override
  Future<void> addTask(TaskModel task) async {
    final hiveBox = await Hive.openBox<TaskModel>('tasks');
    hiveBox.put(task.id, task);
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final hiveBox = await Hive.openBox<TaskModel>('tasks');
    return hiveBox.values.toList();
  }

  @override
  Future<void> removeTask(String id) async {
    final hiveBox = await Hive.openBox<TaskModel>('tasks');
    return hiveBox.delete(id);
  }

  @override
  Future<void> updateTask(TaskModel newTask) async {
    final hiveBox = await Hive.openBox<TaskModel>('tasks');
    return hiveBox.put(newTask.id, newTask);
  }
}
