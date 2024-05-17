import 'package:abol_test/common/bloc_scope.dart';
import 'package:abol_test/common/di.dart';
import 'package:abol_test/data/repositories/local_repo.dart';
import 'package:abol_test/design/screens/tasks_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalRepository.init();
  DI.init();

  runApp(const BlocScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const TasksScreen(),
    );
  }
}
