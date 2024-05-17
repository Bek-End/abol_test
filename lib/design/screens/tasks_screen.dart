import 'package:abol_test/design/logic/bloc/task_bloc.dart';
import 'package:abol_test/design/widgets/loading_widget.dart';
import 'package:abol_test/design/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late final TaskBloc _taskBloc;

  @override
  void initState() {
    _taskBloc = context.read<TaskBloc>();
    super.initState();
  }

  void _addTask() {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _AddTaskBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tasks'),
      ),
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is! TaskCompleteState) return const LoadingWidget();

            final tasks = state.tasks;

            return ListView.builder(
              itemCount: tasks.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, index) {
                final task = tasks[index];
                return Dismissible(
                  key: Key(task.id),
                  confirmDismiss: (direction) async {
                    if (!task.isDone) return false;

                    return showDialog<bool?>(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: const Text(
                            'Are you sure you want to delete the task?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    ).then((value) {
                      if (value == true) {
                        _taskBloc.add(TaskDeleteEvent(task.id));
                        return true;
                      } else {
                        return false;
                      }
                    });
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(
                        task.data,
                        overflow: TextOverflow.visible,
                      ),
                      trailing: Checkbox(
                        value: task.isDone,
                        onChanged: (value) {
                          _taskBloc.add(TaskChangeStatusEvent(task));
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AddTaskBottomSheet extends StatefulWidget {
  const _AddTaskBottomSheet();

  @override
  State<_AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<_AddTaskBottomSheet> {
  late final _taskDescrCtrl = TextEditingController()..addListener(_listen);
  late final _isAddBtnActive = BehaviorSubject<bool>.seeded(false);

  void _listen() {
    _isAddBtnActive.add(_taskDescrCtrl.text.trim().isNotEmpty);
  }

  void _createTask() {
    context.read<TaskBloc>().add(TaskCreateEvent(data: _taskDescrCtrl.text));
    _taskDescrCtrl.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormFieldWidget(
            maxLines: 5,
            label: 'Task description',
            controller: _taskDescrCtrl,
          ),
          const SizedBox(height: 16),
          StreamBuilder<bool>(
            stream: _isAddBtnActive.stream,
            builder: (context, snapshot) {
              return ElevatedButton(
                onPressed: snapshot.data ?? false ? _createTask : null,
                child: const Text('Add'),
              );
            },
          ),
        ],
      ),
    );
  }
}
