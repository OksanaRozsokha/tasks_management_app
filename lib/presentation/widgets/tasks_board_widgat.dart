import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tasks_manager_app/domain/entities/task_entity.dart';
import 'package:tasks_manager_app/domain/services/tasks_service.dart';

class TasksBoard extends StatelessWidget {
  final TasksService tasksService;
  TasksBoard(this.tasksService);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {

        if (snapshot.hasError) {
          return Center(
            child: Text(
              '${snapshot.error} occured',
              style: TextStyle(fontSize: 18),
            ),
          );

        } else if (snapshot.hasData) {
          final tasks = snapshot.data as List<TaskEntity>;
          return Row(
            children: [
              Column(
                children: [
                  Text('Incompleted tasks'),
                  TextButton(
                    child: Text('Add New Task'),
                    onPressed: () {

                    },
                    )
                ],

              ),
              Column (
                children: [
                  Text('Completed tasks'),
                ],
              )
            ],
          );
        }
      }

      return Center(
        child: CircularProgressIndicator(),
      );
      },

      future: tasksService.getAllTasks(),
    );
  }
}
