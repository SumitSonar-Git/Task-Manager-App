import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/model%20class/taskmodel.dart';

class TaskProvider with ChangeNotifier {
  // Using a private variable with a getter allows you to maintain better control over how the internal data is accessed and
  //modified Using a private variable with a getter allows you to maintain better control over how the internal data is accessed
  // and modified
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void loadTasks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? tasksStringList = pref.getStringList('tasks');
    if (tasksStringList != null) {
      _tasks = tasksStringList
          .map((taskString) => Task.fromJson(jsonDecode(taskString)))
          .toList();
      notifyListeners();
    }
  }

  void saveTasks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> tasksStringList =
        _tasks.map((task) => jsonEncode(task.toJson())).toList();
    pref.setStringList('tasks', tasksStringList);
  }

  addTask(Task task) {
    _tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  // void updateTask(String id, Task newTask) {
  //   final index = _tasks.indexWhere((task) => task.id == id);
  //   if (index >= 0) {
  //     _tasks[index] = newTask;
  //     saveTasks();
  //     notifyListeners();
  //   }
  // }

  deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    saveTasks();
    notifyListeners();
  }
}
