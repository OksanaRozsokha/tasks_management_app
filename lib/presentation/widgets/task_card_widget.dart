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
    return Scaffold(
      appBar: AppBar(
        title: Text('Task details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mark task as completed', style: TextStyle(fontSize: 16),),
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
                    hintText: 'Add a description to the task'
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () => _selectCompletionDate(context),
                  child: completionDateController != null ? _getTextCompletionDateWidget(completionDateController!) : Text('Add Completion Date', style: TextStyle(fontSize: 16),),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(15.0),
                child: TextButton(
                  child: Text('Remove this task', style: TextStyle(color: Colors.red.shade600, fontSize: 16),),
                  onPressed: () {
                    tasksService.removeTask(task);
                    Navigator.of(context).pop();
                  },
                )
              ),

              Padding(
                padding: EdgeInsets.all(15.0),
                child: ElevatedButton(
                  child: Text('Save', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,),),
                  style: ElevatedButton.styleFrom(
                    primary: _isTaskDataChangedCondition() && titleInputController.text.trim().length> 0 ? Color(0xFF32AB32) : Color(0xFFDDDDDD),
                    shadowColor: Colors.black,
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0, left: 8.0),
                    minimumSize: Size(140, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    animationDuration: Duration(milliseconds: 100),
                    alignment: Alignment.center,
                  ),
                  onPressed: () {
                    _onSaveBtn();
                  },
                )

              ),
            ],
          ),
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
    var textColor;
    if (todayTimestamp <= taskTimestamp) {
      completionDatedescription = 'The completion date is: ';
      textColor = Color(0xFF32AB32);

    } else {
      completionDatedescription = 'The completion date is expired: ';
      textColor = Colors.red.shade700;
    }

    return Text('$completionDatedescription ${completionDate.day}/${completionDate.month}/${completionDate.year}', style: TextStyle(color: textColor, fontSize: 16),);
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