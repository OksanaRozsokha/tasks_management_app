import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:tasks_manager_app/domain/entities/task_entity.dart';
import 'package:tasks_manager_app/utils/dates_operations.dart';

class  ShortTaskBlock extends StatefulWidget {
  final TaskEntity task;
  ShortTaskBlock(this.task);

  @override
   _ShortTaskBlockState createState() => _ShortTaskBlockState( task);
}

class _ShortTaskBlockState extends State<ShortTaskBlock> {
  final TaskEntity task;
  _ShortTaskBlockState(this.task);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all( Radius.circular(10.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Padding(
         padding: EdgeInsets.all(10.0),
         child: Column(
          children: [
            Text(_getTaskTitle(), ),
            SizedBox(
              height: 5,
            ),

            if (task.completionDate != null)
              _getCompletionDateWidget(),
          ],
        ),
      ),
      )
    );

  }

  String _getTaskTitle() {
    var _title = task.title;
    EventEmitter emitter = task.emitter;
    emitter.on('titleChanged', context, (ev, context) {
      if (this.mounted) {
        setState(() {
        _title = ev.eventData as String;
      });
      }

      emitter.clear();
    });

    return _title;
  }

   Widget _getCompletionDateWidget() {
    var _completionDateTimeStamp = task.completionDate;
    EventEmitter emitter = task.emitter;
    emitter.on('dateChanged', context, (ev, context) {
      if (this.mounted) {
        setState(() {
          _completionDateTimeStamp = ev.eventData as int;
        });
      }

      emitter.clear();
    });

    return _buildCompletionDateBuilder(_completionDateTimeStamp!);
  }

  Widget _buildCompletionDateBuilder(int taskTimestamp) {
    var completionDate = convertTimestampToDate(taskTimestamp);
    var todayDate = DateTime.now();
    var todayResetedTimeDate = todayDate.subtract(Duration(hours: todayDate.hour, minutes: todayDate.minute, seconds: todayDate.second, milliseconds: todayDate.millisecond, microseconds: todayDate.microsecond));
    var todayTimestamp = convertDateToTimestamp(todayResetedTimeDate);
    var isExpired = todayTimestamp <= taskTimestamp;
    return
      Text('${completionDate.day}/${completionDate.month}/${completionDate.year}', style: TextStyle(
        color: isExpired ?  Colors.green : Colors.red, fontSize: 13,
      )
    );
  }
}