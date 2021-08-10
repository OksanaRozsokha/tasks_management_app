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

  addTask({required String title, required bool isCompleted, String? description, int? completionDate}) async {
    try {
      TaskEntity taskEntity = TaskEntity(title: title, isCompleted: isCompleted, description: description, completionDate: completionDate);
      await tasksRepository.saveTaskEntity(taskEntity);
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