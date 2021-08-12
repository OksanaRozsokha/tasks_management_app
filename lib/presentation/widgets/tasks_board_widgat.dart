import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tasks_manager_app/domain/entities/task_entity.dart';
import 'package:tasks_manager_app/domain/services/tasks_service.dart';
import 'package:tasks_manager_app/presentation/widgets/short_task_block_widget.dart';
import 'package:tasks_manager_app/presentation/widgets/task_card_widget.dart';

class TasksBoard extends StatefulWidget {
  final TasksService tasksService;
  TasksBoard(this.tasksService);

  @override
   _TasksBoardState createState() => _TasksBoardState(tasksService);

}

class _TasksBoardState extends State<TasksBoard> {
  final TasksService tasksService;
  late Future<List<TaskEntity>> tasksFuture;
  _TasksBoardState(this.tasksService);


  @override
   void initState() {
    super.initState();
    tasksFuture = _getTasksList();
    // tasksService.getAllTasks().then((value) => null)
  }

  Future<List<TaskEntity>>  _getTasksList() async {
    return await tasksService.getAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tasksFuture,
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
          print('WIDGET HERE $tasks');
          return Row(
            children: [
              Column(
                children: [
                  Text('Incompleted tasks'),
                  Container(
                    width: 200,
                    height: 200,
                    child: ListView(
                      key: Key(tasks.length.toString()),
                      children: _buildUnCompletedTasksList(tasks)
                    ),
                  )

                ],
              ),

              Column (
                children: [
                  Text('Completed tasks'),
                  Container(
                    width: 200,
                    height: 200,
                    child: ListView(
                      key: Key(tasks.length.toString()),
                      children: _buildCompletedTasksList(tasks)
                    ),
                  )
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
    );
  }

  List<TaskEntity> _getUpdatedTasksList (List<TaskEntity> tasks) {
    EventEmitter emitter = tasksService.emitter;
    emitter.on('addTask', context, (ev, context) {
      if (this.mounted) {
        setState(() {
          var newTask = ev.eventData as TaskEntity;
          var isThisTaskExistInList = tasks.contains(newTask);
          if (isThisTaskExistInList == false) {
            tasks.add(ev.eventData as TaskEntity);
          }
        });
      }

      emitter.clear();
    });

    emitter.on('updateTask', context, (ev, context) {
      if (this.mounted) {
        setState(() {
          var newTask = ev.eventData as TaskEntity;
          var taskToUpdate = tasks.firstWhere((task) => task.id == newTask.id);
          int taskToUpdateIndex = tasks.indexOf(taskToUpdate);
          tasks[taskToUpdateIndex] = newTask;
        });
      }

      emitter.clear();
    });

    emitter.on('removeTask', context, (ev, context) {
      if (this.mounted) {
        setState(() {
          var newTask = ev.eventData as TaskEntity;
          var taskToRemove = tasks.firstWhere((task) => task.id == newTask.id);
          tasks.remove(taskToRemove);
        });
      }

      emitter.clear();
    });

    return tasks;
  }

  List<Widget> _buildUnCompletedTasksList(tasks) {
    var allTasks  = _getUpdatedTasksList(tasks);

    return List.generate(allTasks.length,(index){
      if (!allTasks[index].isCompleted) {
        return  GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => TaskCard(tasksService, allTasks[index]),
            );
          },
          onLongPress: (){
              // open dialog OR navigate OR do what you want
          },
          child: ShortTaskBlock(allTasks[index]),
        );
      } else {
        return Container();
      }
    });
  }


  List<Widget> _buildCompletedTasksList(tasks) {
    var allTasks  = _getUpdatedTasksList(tasks);
    return List.generate(allTasks.length,(index){
      if (allTasks[index].isCompleted) {
        return  GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => TaskCard(tasksService, allTasks[index]),
            );
          },
          onLongPress: (){
              // open dialog OR navigate OR do what you want
          },
          child: ShortTaskBlock(allTasks[index]),
        );
      } else {
        return Container();
      }
    });
  }
}
