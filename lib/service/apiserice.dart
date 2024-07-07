import 'dart:convert';

import 'package:flutter_application_to_do_app/model/taskmodel.dart';
import 'package:flutter_application_to_do_app/model/usermodel.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> signUp(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email);
    await prefs.setString('password', user.password);
  }

  Future<User?> signIn(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedEmail = prefs.getString('email');
    final String? storedPassword = prefs.getString('password');

    if (storedEmail == email && storedPassword == password) {
      final String? username = prefs.getString('username');
      return User(username: username!, email: email, password: password);
    }
    return null;
  }

  Future<void> signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isSignedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') != null;
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    final String? email = prefs.getString('email');
    final String? password = prefs.getString('password');

    if (username != null && email != null && password != null) {
      return User(username: username, email: email, password: password);
    }
    return null;
  }

  Future<void> addTask(Task task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> tasksStringList = prefs.getStringList('tasks') ?? [];
    tasksStringList.add(json.encode(task.toMap()));
    await prefs.setStringList('tasks', tasksStringList);
  }

  Future<List<Task>> getTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? tasksStringList = prefs.getStringList('tasks');
    if (tasksStringList != null) {
      return tasksStringList.map((taskString) {
        Logger().f(taskString);
        final Map<String, dynamic> taskMap = json.decode(taskString);
        return Task.fromMap(taskMap);
      }).toList();
    }
    return [];
  }

  Future<void> updateTaskCompletionStatus(
      String title, String description, bool newStatus) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> tasksStringList = prefs.getStringList('tasks') ?? [];

    // Find the index of the task to update
    final index = tasksStringList.indexWhere((taskString) {
      final Map<String, dynamic> taskMap = json.decode(taskString);
      final existingTask = Task.fromMap(taskMap);
      return existingTask.title == title &&
          existingTask.description == description;
    });

    // If the task is found, update its completion status
    if (index != -1) {
      final Map<String, dynamic> taskMap = json.decode(tasksStringList[index]);
      final updatedTask = Task.fromMap(taskMap);
      updatedTask.isComplete = newStatus; // Update the completion status
      tasksStringList[index] = json.encode(updatedTask.toMap());
      await prefs.setStringList('tasks', tasksStringList);
    }
  }

  Future<void> deleteTask(Task task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> tasksStringList = prefs.getStringList('tasks') ?? [];

    // Find the task to delete
    final index = tasksStringList.indexWhere((taskString) {
      final Map<String, dynamic> taskMap = json.decode(taskString);
      final existingTask = Task.fromMap(taskMap);
      return existingTask.title == task.title &&
          existingTask.description == task.description;
    });

    // Remove the task if it exists
    if (index != -1) {
      tasksStringList.removeAt(index);
      await prefs.setStringList('tasks', tasksStringList);
    }
  }

  Future<void> updateTask(Task task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasksStringList = prefs.getStringList('tasks') ?? [];

    // Find the index of the task to update
    final index = tasksStringList.indexWhere((taskString) {
      final Map<String, dynamic> taskMap = json.decode(taskString);
      final existingTask = Task.fromMap(taskMap);
      return existingTask.title == task.title &&
          existingTask.description == task.description;
    });

    if (index != -1) {
      final Map<String, dynamic> taskMap = json.decode(tasksStringList[index]);
      final existingTask = Task.fromMap(taskMap);

      existingTask.isComplete = task.isComplete; // Update completion status

      tasksStringList[index] = json.encode(existingTask.toMap());

      await prefs.setStringList('tasks', tasksStringList);
      Logger().e(task.color);
      Logger().e(task.deadline);
      Logger().e(task.description);
      Logger().e(task.isComplete);
      Logger().e(task.title);
    }
  }
}
