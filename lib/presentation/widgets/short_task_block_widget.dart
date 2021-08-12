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
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(_getTaskTitle()),
          ),

          if (task.completionDate != null)
          Padding(
            padding: EdgeInsets.all(10.0),
            child: _getCompletionDateWidget(),
          ),
        ],
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
    var todayTimestamp = convertDateToTimestamp(DateTime.now());
    var isExpired = todayTimestamp < taskTimestamp ? false: true;
    return
      Text('${completionDate.day}/${completionDate.month}/${completionDate.year}', style: TextStyle(
        color: isExpired ? Colors.red : Colors.green
      )
    );
  }
}