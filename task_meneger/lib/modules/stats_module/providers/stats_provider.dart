import 'package:flutter/material.dart';


import '../../../shared/model/task.dart';

class StatsProvider extends ChangeNotifier {
  int completed = 0;
  int pending = 0;

  int maxTasksInWeekday = 0;
  int? productiveWeekday;

  final Map<int, int> _donePerWeekday = {};

  void statsInit({
    required List<Task> completedTasks,
    required int upcomingTasksCount,
  }) {
    completed = completedTasks.length;
    pending = upcomingTasksCount;
    _donePerWeekday.clear();
    for (var task in completedTasks) {
      int weekday = task.realisationDate!.weekday;
      _donePerWeekday[weekday] = (_donePerWeekday[weekday] ?? 0) + 1;
    }
    _recalculateMostProductive();

    notifyListeners();
  }

  void addTask() {
    pending++;
    notifyListeners();
  }

  void removeTask(Task task) {
    if (task.isCompleted) {
      completed--;
      _decrementWeekday(task.realisationDate!.weekday);
    } else {
      pending--;
    }
    _recalculateMostProductive();
    notifyListeners();
  }

  void updateTaskStatus(Task task) {
    if (task.isCompleted) {
      completed++;
      pending--;
      _incrementWeekday(task.realisationDate!.weekday);    
    } else if (!task.isCompleted) {
      completed--;
      pending++;
      _decrementWeekday(task.realisationDate!.weekday);
    }
    _recalculateMostProductive();
    notifyListeners();
  }

  void _incrementWeekday(int weekday) {
    _donePerWeekday[weekday] = (_donePerWeekday[weekday] ?? 0) + 1;
  }

  void _decrementWeekday(int weekday) {
    if (_donePerWeekday.containsKey(weekday)) {
      _donePerWeekday[weekday] = _donePerWeekday[weekday]! - 1;
      if (_donePerWeekday[weekday]! <= 0) {
        _donePerWeekday.remove(weekday);
      }
    }
  }

  void _recalculateMostProductive() {
    if (_donePerWeekday.isNotEmpty) {
      final entry = _donePerWeekday.entries.reduce(
        (a, b) => a.value >= b.value ? a : b,
      );
      productiveWeekday = entry.key;
      maxTasksInWeekday = entry.value;
    } else {
      productiveWeekday = null;
      maxTasksInWeekday = 0;
    }
  }

  String get productiveWeekdayName {
    if (productiveWeekday == null) return 'Brak danych';
    const names = [
      'Poniedziałek',
      'Wtorek',
      'Środa',
      'Czwartek',
      'Piątek',
      'Sobota',
      'Niedziela',
    ];
    return names[productiveWeekday! - 1];
  }
}