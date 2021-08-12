import 'package:flutter/material.dart';
import 'package:tasks_manager_app/domain/services/tasks_service.dart';

class  AddNewTaskCard extends StatefulWidget {
  final TasksService tasksService;
  AddNewTaskCard(this.tasksService);

  @override
   _AddNewTaskCardState createState() => _AddNewTaskCardState(tasksService);
}

class _AddNewTaskCardState extends State<AddNewTaskCard> {
  final TasksService tasksService;
  _AddNewTaskCardState(this.tasksService);

  var titleInputController = TextEditingController();
  bool _isTextFieldNotEmpty = false;

  @override
  void dispose() {
    titleInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      child: Container(
        height: 300.0,
        width: 360.0,
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
                onChanged: (text) {
                  _isTextFieldNotEmpty = text.trim().length > 0 ? true : false;
                },
                controller: titleInputController,
                decoration: InputDecoration(
                  hintText: 'Enter a title of the task'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onSaveBtn() {
   if (_isTextFieldNotEmpty) {
      tasksService.addTask(title: titleInputController.text.trim(), isCompleted: false);
      Navigator.of(context).pop();
   } else {
     return null;
   }
  }
}