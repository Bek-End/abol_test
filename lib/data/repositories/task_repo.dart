import 'package:abol_test/data/models/task_model.dart';

abstract class TaskRepo {
  TaskModel createTask(String data);
  TaskModel changeStatusTask(TaskModel task);
}

class TaskRepository implements TaskRepo {
  @override
  TaskModel changeStatusTask(TaskModel task) {
    return task.changeStatusDone();
  }

  @override
  TaskModel createTask(String data) {
    return TaskModel.newTask(data: data);
  }
}
