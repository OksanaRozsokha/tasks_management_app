
class TasksStorage {
  String _data = '{"tasks":[]}';

  String get data => _data;
  void setTasks(String newData) {
    _data = '{"tasks":$newData}';
  }
}
