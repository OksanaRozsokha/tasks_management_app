import 'package:flutter/material.dart';
import 'package:tasks_manager_app/domain/services/tasks_service.dart';
import 'package:tasks_manager_app/presentation/widgets/add_new_task_card_widget.dart';
import 'package:tasks_manager_app/presentation/widgets/tasks_board_widget.dart';

class TasksManagerPage extends StatelessWidget {
  final TasksService tasksService;
  TasksManagerPage(this.tasksService);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF948CB4),
      appBar: AppBar(
        title: Text('Tasks Manager App'),
        centerTitle: true,
      ),
      body: TasksBoard(tasksService),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF32AB32),
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