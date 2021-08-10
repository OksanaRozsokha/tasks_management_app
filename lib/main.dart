
import 'package:flutter/material.dart';
import 'package:tasks_manager_app/data/repositories/tasks_repository.dart';
import 'package:tasks_manager_app/data/tasks_storage.dart';
import 'package:tasks_manager_app/data/repositories/ram_tasks_repository.dart';
import 'package:tasks_manager_app/domain/entities/task_entity.dart';
import 'package:tasks_manager_app/domain/services/tasks_service.dart';
import 'package:tasks_manager_app/presentation/tasks_manager_page.dart';

void main() {
  final tasksService =  _connectToService();

  runApp(MyApp(tasksService));
}

TasksService _connectToService() {
  final TasksRepository ramTasksRepo = RamTasksRepository(TasksStorage());
  TasksService tasksService = TasksService(ramTasksRepo);
  return tasksService;
}


class MyApp extends StatelessWidget {
  final TasksService tasksService;
  MyApp(this.tasksService);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TasksManagerPage(tasksService),
    );
  }
}
