import 'package:tasks_manager_app/data/repositories/tasks_repository.dart';
import 'package:tasks_manager_app/domain/entities/task_entity.dart';

class TasksService {
  final TasksRepository tasksRepository;

  TasksService(this.tasksRepository);

  Future<List<TaskEntity>> getAllTasks () async {
    final tasks = await tasksRepository.getAllTasksEntities();
    print('TASKS SERVICE TASK TITLE ${tasks[0].title}');
    return tasks;
  }

  addTask(TaskEntity task) async {
    try {
      await tasksRepository.saveTaskEntity(task);
      return true;

    } catch(error) {
      return false;
    }
  }

  updateTask(TaskEntity task) async {
     try {
      await tasksRepository.updateTaskEntity(task);
      return true;

    } catch(error) {
      return false;
    }
  }

  removeTask(TaskEntity task) async {
    try {
      tasksRepository.deleteTaskEntity(task);
      return true;

    } catch(error) {
      return false;
    }
  }
}