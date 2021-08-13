import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tasks_manager_app/domain/entities/task_entity.dart';
import 'package:tasks_manager_app/domain/services/tasks_service.dart';
import 'package:tasks_manager_app/presentation/widgets/short_task_block_widget.dart';
import 'package:tasks_manager_app/presentation/pages/task_card_page.dart';

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

  final uncomletedColumnScrollController = ScrollController();
  final comletedColumnScrollController = ScrollController();


  @override
   void initState() {
    tasksFuture = _getTasksList();
    super.initState();
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
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 15,
                    ),

                    Container(
                      width: (MediaQuery.of(context).size.width/2) - 22.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all( Radius.circular(10.0)),
                        color: Color(0xFFDFE8FA),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text('In progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
                          ),
                          Divider(),
                          ListView(

                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            key: Key(tasks.length.toString()),
                            children: _buildUnCompletedTasksList(tasks)
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),

                    Container(
                      width: (MediaQuery.of(context).size.width/2) - 22.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all( Radius.circular(10.0)),
                        color: Color(0xFFDFE8FA),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text('Completed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
                          ),
                          Divider(),
                          ListView(

                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            key: Key(tasks.length.toString()),
                            children: _buildCompletedTasksList(tasks)
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),

                      SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ],
            ),
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
          if (!isThisTaskExistInList) {
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
          child: ShortTaskBlock(allTasks[index]),
        );
      } else {
        return SizedBox();
      }
    });
  }


  List<Widget> _buildCompletedTasksList(tasks) {
    var allTasks  = _getUpdatedTasksList(tasks);
    return List.generate(allTasks.length,(index){
      if (allTasks[index].isCompleted) {
        return  GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => TaskCard(tasksService, allTasks[index]),
            ));
          },
          child: ShortTaskBlock(allTasks[index]),
        );
      } else {
        return SizedBox();
      }
    });
  }
}
