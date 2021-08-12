import 'package:eventify/eventify.dart';
import 'package:tasks_manager_app/data/repositories/tasks_repository.dart';
import 'package:tasks_manager_app/domain/entities/task_entity.dart';

class TasksService {
  final TasksRepository tasksRepository;
  final EventEmitter _emitter;

  TasksService(this.tasksRepository, emitter) : _emitter = emitter;

  EventEmitter get emitter => _emitter;

  Future<List<TaskEntity>> getAllTasks () async {
    final tasks = await tasksRepository.getAllTasksEntities();
    return tasks;
  }

  addTask({required String title, required bool isCompleted, String? description, int? completionDate}) async {
    try {
      TaskEntity taskEntity = TaskEntity.create(title: title, isCompleted: isCompleted, description: description, completionDate: completionDate);
      await tasksRepository.saveTaskEntity(taskEntity);
      emitter.emit('addTask', null, taskEntity);
      return true;

    } catch(error) {
      return false;
    }
  }

  updateTask(TaskEntity task) async {
     try {
      await tasksRepository.updateTaskEntity(task);
      emitter.emit('updateTask', null, task);
      return true;

    } catch(error) {
      return false;
    }
  }

  removeTask(TaskEntity task) async {
    try {
      await tasksRepository.deleteTaskEntity(task);
      emitter.emit('removeTask', null, task);
      return true;

    } catch(error) {
      return false;
    }
  }
}