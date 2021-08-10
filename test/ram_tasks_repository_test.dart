import 'package:tasks_manager_app/data/repositories/ram_tasks_repository.dart';
import 'package:tasks_manager_app/data/tasks_storage.dart';
import 'package:tasks_manager_app/domain/entities/task_entity.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

class TasksStorageFake extends Fake implements TasksStorage {
  String _data = '{"tasks":[]}';
  @override
  String get data => _data;
  @override
  void setTasks(String newData) {
    _data = '{"tasks":$newData}';
  }
}

void main() {
  final taskEntity1 = TaskEntity(title: 'First task', isCompleted: false);
  final taskEntity2 = TaskEntity(title: 'Second task', isCompleted: false, description: 'test description', completionDate: 1628802000000);
  group('Ram Repository', () {
    final storage = TasksStorageFake();
    final ramTasksRepository = RamTasksRepository(storage);
    test('Save new tasks to storage', () {
      ramTasksRepository.saveTaskEntity(taskEntity1);
      ramTasksRepository.saveTaskEntity(taskEntity2);
      final expectedStorage ='{"tasks":[{"id":1,"isCompleted":false,"title":"First task","description":null,"completionDate":null},{"id":2,"isCompleted":false,"title":"Second task","description":"test description","completionDate":1628802000000}]}';
      expect(storage.data, expectedStorage);
    });

    test('Get tasks from storage', ()  {
      final expactedTasksList = [TaskEntity(id: 1, isCompleted: false, title: 'First task') , TaskEntity(id: 2, isCompleted: false, title: 'Second task', description: 'test description', completionDate: 1628802000000)];
      final futureTasks = ramTasksRepository.getAllTasksEntities();

      futureTasks.then((value) {
        print(value[0]);
        expect(value, expactedTasksList);
      });
      expect(futureTasks, completes);
    });

    test('Update Task in Storage', () {
      taskEntity1
      ..setStatus(true)
      ..setTitle('Updated first task')
      ..setDescription('tes desr')
      ..setCompletionDate(12332);
      ramTasksRepository.updateTaskEntity(taskEntity1);
      final expectedStorage ='{"tasks":[{"id":1,"isCompleted":true,"title":"Updated first task","description":"tes desr","completionDate":12332},{"id":2,"isCompleted":false,"title":"Second task","description":"test description","completionDate":1628802000000}]}';
      expect(storage.data, expectedStorage);
    });

    test('Delete Task from Storage', () {
      ramTasksRepository.deleteTaskEntity(taskEntity1);
      final expectedStorage ='{"tasks":[{"id":2,"isCompleted":false,"title":"Second task","description":"test description","completionDate":1628802000000}]}';
      expect(storage.data, expectedStorage);
    });
  });
}