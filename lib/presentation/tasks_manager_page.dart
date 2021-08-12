import 'package:flutter/material.dart';
import 'package:tasks_manager_app/domain/services/tasks_service.dart';
import 'package:tasks_manager_app/presentation/widgets/add_new_task_card_widget.dart';
import 'package:tasks_manager_app/presentation/widgets/task_card_widget.dart';
import 'package:tasks_manager_app/presentation/widgets/tasks_board_widgat.dart';

class TasksManagerPage extends StatelessWidget {
  final TasksService tasksService;
  TasksManagerPage(this.tasksService);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks Manager App'),
        centerTitle: true,
      ),
      body: TasksBoard(tasksService),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AddNewTaskCard(tasksService),
          );
        },
      ),
    );
  }
}