import 'package:eventify/eventify.dart';

class TaskEntity {
  late int? _id;
  late bool _isCompleted;
  late String _title;
  late String? _description;
  late int? _completionDate;
  late EventEmitter _emitter;

  TaskEntity({id, required isCompleted, required title, required emitter, description, completionDate})
    :
    _id = id,
    _isCompleted = isCompleted,
    _title = title,
    _description = description,
    _completionDate = completionDate,
    _emitter = emitter;

  int? get id => _id;

  bool get isCompleted => _isCompleted;

  String get title => _title;

  String get description => _description ?? '';

  int? get completionDate => _completionDate;

  EventEmitter get emitter => _emitter;

  void setId(int id) {
    _id = id;
  }

  void setStatus(bool isCompleted) {
    _isCompleted = isCompleted;
    emitter.emit('statusChanged', null, _isCompleted);
  }

  void setTitle(String newTitle) {
    _title = newTitle;
    emitter.emit('titleChanged', null, _title);
  }

  void setDescription(String? newDescription) {
    _description = newDescription;
    emitter.emit('descriptionChanged', null, _description);
  }

  void setCompletionDate(int? newCompletionDate) {
    _completionDate = newCompletionDate;
    emitter.emit('dateChanged', null, _completionDate);
  }

  factory TaskEntity.create({ id, required isCompleted, required title, description, completionDate }) {
    var evEmitter = new EventEmitter();
    return TaskEntity(id: id, isCompleted: isCompleted, title: title, emitter: evEmitter, description: description, completionDate: completionDate);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'isCompleted': _isCompleted,
      'title': _title,
      'description': _description,
      'completionDate': _completionDate
    };
  }

  @override
  bool operator == (Object other) {
    TaskEntity otherTask = other as TaskEntity;
    if (id != otherTask.id)  {
      return false;
    }

    if (isCompleted != otherTask.isCompleted) {
      return false;
    }

    if (title != otherTask.title) {
      return false;
    }

    if (description != otherTask.description) {
      return false;
    }

    if (completionDate != otherTask.completionDate) {
      return false;
    }

    return true;
  }
}
