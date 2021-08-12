import 'dart:convert';
import 'package:tasks_manager_app/data/repositories/tasks_repository.dart';
import 'package:tasks_manager_app/data/tasks_storage.dart';
import 'package:tasks_manager_app/domain/entities/task_entity.dart';

class RamTasksRepository extends TasksRepository {
  TasksStorage tasksStorage;
  int _lastId = 0;

  RamTasksRepository(this.tasksStorage);

  int _generateId() {
    return _lastId += 1;
  }

  Future<List<TaskEntity>> getAllTasksEntities() async {
    List<TaskEntity> tasksList = _getTasksFromStorage();
    return await Future.delayed(Duration(milliseconds: 0),() => tasksList);
  }

  saveTaskEntity(TaskEntity taskEntity) async {
    taskEntity.setId(_generateId());
    List<TaskEntity> tasksList = _getTasksFromStorage();
    tasksList.add(taskEntity);
    _setTasksToStorage(tasksList);
    return true;
  }

  updateTaskEntity(TaskEntity taskEntity) async {
    List<TaskEntity> tasksList = _getTasksFromStorage();
    var taskToUpdate = tasksList.firstWhere((task) => task.id == taskEntity.id);
    int taskToUpdateIndex = tasksList.indexOf(taskToUpdate);
    tasksList[taskToUpdateIndex] = taskEntity;
    // taskToUpdate = taskEntity;
    _setTasksToStorage(tasksList);
    return true;
  }

  deleteTaskEntity(TaskEntity taskEntity) async {
    List<TaskEntity> tasksList = _getTasksFromStorage();
    var taskToremove = tasksList.firstWhere((task) => task.id == taskEntity.id);
    tasksList.remove(taskToremove);
    _setTasksToStorage(tasksList);
    return true;
  }

  List<TaskEntity> _getTasksFromStorage() {
    var tasksJson = jsonDecode(tasksStorage.data)['tasks'] as List;
    List<TaskEntity> tasksList = tasksJson.map((taskJson) => TaskEntity.create(id: taskJson['id'], isCompleted: taskJson['isCompleted'], title: taskJson['title'], description: taskJson['description'], completionDate: taskJson['completionDate'])).toList();
    return tasksList;
  }

  void _setTasksToStorage(tasksList) {
    String tasksJson = jsonEncode(tasksList.map((TaskEntity task) => task.toJson()).toList()).toString();
    tasksStorage.setTasks(tasksJson);
    print(tasksStorage.data);
  }
}