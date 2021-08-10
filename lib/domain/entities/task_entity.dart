class TaskEntity {
  late int? _id;
  late bool _isCompleted;
  late String _title;
  late String? _description;
  late int? _completionDate;

  TaskEntity({ id, required isCompleted, required title, description, completionDate })
    :
    _id = id,
    _isCompleted = isCompleted,
    _title = title,
    _description = description,
    _completionDate = completionDate;

  int? get id {
    return _id;
  }

  bool get isCompleted {
    return _isCompleted;
  }

  String get title {
    return _title;
  }

  String? get description {
    return _description;
  }

  int? get completionDate {
    return _completionDate;
  }

  void setId(int id) {
    _id = id;
  }

  void setStatus(bool isCompleted) {
    _isCompleted = isCompleted;
  }

  void setTitle(String newTitle) {
    _title = newTitle;
  }

  void setDescription(String? newDescription) {
    _description = newDescription;
  }

  void setCompletionDate(int? newCompletionDate) {
    _completionDate = newCompletionDate;
  }

  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      id: json['id'],
      isCompleted: json['isCompleted'],
      title: json['title'],
      description: json['description'],
      completionDate: json['completionDate'],
    );
  }

  Map<String, dynamic> toJson() {
    print('ETITY TO JSON TEST');
    return {
      'id': _id,
      'isCompleted': _isCompleted,
      'title': _title,
      'description': _description,
      'completionDate': _completionDate
    };
  }

  @override
  bool operator ==(Object other) {
    TaskEntity otherTask = other as TaskEntity;
    if (id != other.id)  {
      return false;
    }

    if (isCompleted != other.isCompleted) {
      return false;
    }

    if (title != other.title) {
      return false;
    }

    if (description != other.description) {
      return false;
    }

    if (completionDate != other.completionDate) {
      return false;
    }

    return true;
  }
}
