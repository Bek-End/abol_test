import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel with HiveObjectMixin {
  TaskModel({
    required String id,
    required String data,
    required this.isDone,
  })  : _id = id,
        _data = data;

  TaskModel.newTask({required String data})
      : _id = DateTime.now().millisecondsSinceEpoch.toString(),
        _data = data,
        isDone = false;

  @HiveField(0)
  final String _id;
  @HiveField(1)
  final String _data;
  @HiveField(2)
  final bool isDone;

  String get id => _id;
  String get data => _data;

  TaskModel changeStatusDone() {
    return TaskModel(id: _id, data: _data, isDone: !isDone);
  }
}
