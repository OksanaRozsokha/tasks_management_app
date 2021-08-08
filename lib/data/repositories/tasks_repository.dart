import 'package:tasks_manager_app/domain/entities/task_entity.dart';

abstract class TasksRepository {


  Future<List<TaskEntity>> getAllTasksEntities() async {
    return [];
  }

  saveTaskEntity(TaskEntity taskEntity) async {

  }

  updateTaskEntity(TaskEntity taskEntity) async {

  }

  deleteTaskEntity(TaskEntity taskEntity) async {

  }
}