import 'package:flutter/material.dart';
import 'package:task_meneger/modules/task_module/data/repo/task_repo.dart';
import 'package:task_meneger/modules/task_module/data/services/notification_service.dart';
import 'package:task_meneger/shared/model/task.dart';

class TaskProvider extends ChangeNotifier{
  TaskProvider(this._repo,this.notificationService);
  final TaskRepo _repo;
  final NotificationService  notificationService;
  List<Task> _tasks = [];

  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get upcomingTasks => _tasks.where((task) => !task.isCompleted).toList();
  List<int?> get upcomingTasksIds => upcomingTasks.map((t) => t.id).toList();

  Future<void> getTasks() async {
    _tasks = await _repo.getTasks();
    notifyListeners();
  }

  Future<void> addTask(String name,String? description,DateTime deadline) async{    
    final Task task = Task(title: name, description: description ?? '', deadline: deadline, isCompleted: false,realisationDate: null);
    final int id = await _repo.insertTask(task);
    final Task updatedTask = task.copyWith(id: id);
    _tasks.add(updatedTask);
    await notificationService.schedule(updatedTask.id!,name,description,deadline.subtract(Duration(minutes: 15)));
    notifyListeners();
  }

  Future<void> realisionTask(Task task,bool val) async {
    task = task.copyWith(isCompleted: val, realisationDate: DateTime.now());
    if (val) {
      await notificationService.cancel(task.id!);
    } else {
      await notificationService.schedule(task.id!,task.title,task.description,task.deadline.subtract(Duration(minutes: 15)));
    }
    await _repo.updateTask(task);
    notifyListeners();
  }

  Future<void> removeTask(Task task) async {
    await _repo.deleteTask(task.id!);
    _tasks.removeWhere((t) => t.id == task.id);
    await notificationService.cancel(task.id!);
    notifyListeners();
  }

  Future<void> updateTasks(int id,String name,String? description,DateTime deadline,DateTime? realisationDate) async {
    final Task task = Task(id:id,title: name, description: description ?? '', deadline: deadline, isCompleted: false, realisationDate: realisationDate);
    await _repo.updateTask(task);
    int index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await notificationService.update(id, name, description,deadline.subtract(Duration(minutes: 15)));
    } else {
      _tasks.add(task);
    }
    notifyListeners();
  }


  void sortTasksByDeadline() {
    _tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    notifyListeners();
  }

  @visibleForTesting
  void setTasks(List<Task> tasks) {
    _tasks = tasks;
  }

  @visibleForTesting
  void addTasklist(Task task) {
    _tasks.add(task);
  }
}