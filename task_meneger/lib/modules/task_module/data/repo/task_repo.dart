import 'package:task_meneger/modules/task_module/data/source/task_db.dart';
import 'package:task_meneger/shared/model/task.dart';

class TaskRepo {
  Future<List<Task>> getTasks() async {
   final maps = await TaskDb.instance.getTasks();     
    return List.generate(maps.length, (i) {
      return Task.fromJson(maps[i]);
    });
  }

  Future<void> updateTask(Task task) async {
    await TaskDb.instance.updateTask(task.toJson());
  }

  Future<int> insertTask(Task task) async {
    return await TaskDb.instance.insertTask(task.toJson());
  }

  Future<void> deleteTask(int id) async {
    await TaskDb.instance.deleteTask(id);
  }
}