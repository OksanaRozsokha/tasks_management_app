import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:tasks_manager_app/data/repositories/tasks_repository.dart';
import 'package:tasks_manager_app/data/tasks_storage.dart';
import 'package:tasks_manager_app/data/repositories/ram_tasks_repository.dart';
import 'package:tasks_manager_app/domain/services/tasks_service.dart';
import 'package:tasks_manager_app/presentation/pages/tasks_manager_page.dart';

void main() {
  TasksRepository ramTasksRepo = RamTasksRepository(StringTasksStorage());
  EventEmitter emitter = new EventEmitter();
  TasksService tasksService = TasksService(ramTasksRepo, emitter);

  runApp(MyApp(tasksService));
}

class MyApp extends StatelessWidget {
  final TasksService tasksService;
  MyApp(this.tasksService);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF514980),
      ),
      home: TasksManagerPage(tasksService),
    );
  }
}
