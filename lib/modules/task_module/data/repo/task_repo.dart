import 'package:task_meneger/modules/task_module/data/source/task_db.dart';
import 'package:task_meneger/shared/model/task.dart';

class TaskRepo {

  const TaskRepo(this._db);

  final TaskDb _db; 

  Future<List<Task>> getTasks() async {
   final maps = await _db.getTasks();     
    return List.generate(maps.length, (i) {
      return Task.fromJson(maps[i]);
    });
  }

  Future<void> updateTask(Task task) async {
    await _db.updateTask(task.toJson());
  }

  Future<int> insertTask(Task task) async {
    return await _db.insertTask(task.toJson());
  }

  Future<void> deleteTask(int id) async {
    await _db.deleteTask(id);
  }
}