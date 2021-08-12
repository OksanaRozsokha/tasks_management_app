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
  bool isTextFieldNotEmpty = false;

  @override
  void dispose() {
    titleInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 200.0,
        width: 360.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.done),
                    color: isTextFieldNotEmpty ? Color(0xFF32AB32) : Color(0xFFCCCCCC),
                    onPressed: () {
                      _onSaveBtn();
                    },
                  ),

                  IconButton(
                    color: Colors.red.shade700,
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
            ),

            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 25.0),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    isTextFieldNotEmpty = text.trim().length > 0;
                  });

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
   if (isTextFieldNotEmpty) {
      tasksService.addTask(title: titleInputController.text.trim(), isCompleted: false);
      Navigator.of(context).pop();
   } else {
     return null;
   }
  }
}