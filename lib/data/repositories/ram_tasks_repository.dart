import 'dart:convert';
import 'package:tasks_manager_app/data/repositories/tasks_repository.dart';
import 'package:tasks_manager_app/domain/entities/task_entity.dart';

class RamTasksRepository extends TasksRepository {
  String storage;
  int _lastId = 0;

  RamTasksRepository(this.storage);

  int _generateId() {

    return _lastId += 1;
  }

  Future<List<TaskEntity>> getAllTasksEntities() async {
    List<TaskEntity> tasksList = _getTasksFromStorage();
    return await Future.delayed(Duration(milliseconds: 0),() => tasksList);
  }

  saveTaskEntity(TaskEntity taskEntity) async {
    taskEntity.setId(_generateId());
    print('Id seted to the task from TaskRepo');
    List<TaskEntity> tasksList = _getTasksFromStorage();
    print('Got tasksList from TaskRepo (saveTaskEntity()): $tasksList');
    tasksList.add(taskEntity);
    print('Added task __$taskEntity to the tasksList from TaskRepo (saveTaskEntity()): $tasksList');
    _setTasksToStorage(tasksList);
    print('Seted all tasks to Storage from TaskRepo (saveTaskEntity()): $tasksList');
    return true;
  }

  updateTaskEntity(TaskEntity taskEntity) async {
    List<TaskEntity> tasksList = _getTasksFromStorage();
    var taskToUpdate = tasksList.firstWhere((task) => task.id == taskEntity.id);
    int taskToUpdateIndex = tasksList.indexOf(taskToUpdate);
    print('SHOW TASK TO UPDATE RAM_REPO: ${taskToUpdate.title}');
    print('SHOW TASKENTITY RAM_REPO: ${taskEntity.title}');
    tasksList[taskToUpdateIndex] = taskEntity;
    taskToUpdate = taskEntity;
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
    var tasksJson = jsonDecode(storage)['tasks'] as List;
    print('get tasks from list from TasksRepo (_getTasksFromStorage()): $tasksJson');
    List<TaskEntity> tasksList = tasksJson.map((taskJson) => TaskEntity.fromJson(taskJson)).toList();
    print('Converted list from json from TasksRepo (_getTasksFromStorage()): $tasksList');
    return tasksList;
  }

  void _setTasksToStorage(tasksList) {
    print('SET TASK TO STORAGE TEST');
    String tasksJson = jsonEncode(tasksList.map((TaskEntity task) {
      print('TASK FROM TASKREPO (_setTasksToStorage): $task');
      var jsonTask = task.toJson();
      print('JSOnTASK FROM TASKREPO (_setTasksToStorage): $jsonTask');
      return jsonTask;
      }).toList()).toString();
    print('tasksJson executed from from ramTasksRepo (_setTasksToStorage())');
    storage = '{"tasks": $tasksJson}';
    print('Updated storage from ramTasksRepo (_setTasksToStorage()): $storage');
  }
}