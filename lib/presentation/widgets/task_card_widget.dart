import 'package:flutter/material.dart';
import 'package:tasks_manager_app/domain/entities/task_entity.dart';
import 'package:tasks_manager_app/domain/services/tasks_service.dart';
import 'package:tasks_manager_app/utils/dates_operations.dart';

class  TaskCard extends StatefulWidget {
  final TasksService tasksService;
  final TaskEntity task;
  TaskCard(this.tasksService, this.task);

  @override
   _TaskCardState createState() => _TaskCardState(tasksService, task);
}

class _TaskCardState extends State<TaskCard> {
  final TasksService tasksService;
  final TaskEntity task;
  _TaskCardState(this.tasksService, this.task);

  var titleInputController = TextEditingController();
  var descriptionInputController = TextEditingController();

  late bool isCompletedController;
  late int? completionDateController;

  @override
  void initState() {
    isCompletedController = task.isCompleted;
    completionDateController = task.completionDate;
    titleInputController.text = task.title;
    descriptionInputController.text = task.description;

    super.initState();
  }

  @override
  void dispose() {
    titleInputController.dispose();
    descriptionInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [

                  IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () {
                      _onSaveBtn();
                    },
                  ),

                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
            ),

            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: titleInputController,
                decoration: InputDecoration(
                  hintText: 'Enter a title of the task'
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(15.0),
              child:  Row(
                children: [
                  Text('Сompleted'),
                  Checkbox(
                    value: isCompletedController,
                    onChanged: (isChecked) {
                      setState(() {
                        isCompletedController = isChecked!;
                      });
                    }
                  )
                ],
              )
            ),

            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: descriptionInputController,
                decoration: InputDecoration(
                  hintText: 'Add a description of the task'
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () => _selectCompletionDate(context),
                child: completionDateController != null ? _getTextCompletionDateWidget(completionDateController!) : Text('Add Completion Date'),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextButton(
                child: Text('Remove this task'),
                onPressed: () {
                  tasksService.removeTask(task);
                  Navigator.of(context).pop();
                },

              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTextCompletionDateWidget(int taskTimestamp) {
    var completionDate = convertTimestampToDate(taskTimestamp);
    var todayDate = DateTime.now();
    var todayResetedTimeDate = todayDate.subtract(Duration(hours: todayDate.hour, minutes: todayDate.minute, seconds: todayDate.second, milliseconds: todayDate.millisecond, microseconds: todayDate.microsecond));
    var todayTimestamp = convertDateToTimestamp(todayResetedTimeDate);
    var completionDatedescription;
    if (todayTimestamp <= taskTimestamp) {
      completionDatedescription = 'The completion date is: ';
    } else {
      completionDatedescription = 'The completion date is expired: ';
    }

    return Text('$completionDatedescription ${completionDate.day}/${completionDate.month}/${completionDate.year}');
  }

  Future<void> _selectCompletionDate(BuildContext context) async {
    var selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101)
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        completionDateController = convertDateToTimestamp(picked);
      });
  }

  _onSaveBtn() {
    if ((_isTaskDataChangedCondition()) && titleInputController.text.trim().length> 0) {
      if (task.title.trim() != titleInputController.text.trim()) {
        task.setTitle(titleInputController.text.trim());
      }

      if (task.isCompleted != isCompletedController) {
        task.setStatus(isCompletedController);
      }

      if (task.description.trim() != descriptionInputController.text.trim()) {
        task.setDescription(descriptionInputController.text.trim());
      }

      if (task.completionDate != completionDateController) {
        task.setCompletionDate(completionDateController);
      }

      tasksService.updateTask(task);
      Navigator.of(context).pop();
    } else {
      return null;
    }
  }

  bool _isTaskDataChangedCondition() {
    return (task.title.trim() != titleInputController.text.trim()) ||
                        (task.isCompleted != isCompletedController) ||
                        (task.description.trim() != descriptionInputController.text.trim()) ||
                        (task.completionDate != completionDateController);
  }
}