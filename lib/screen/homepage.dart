import 'package:flutter/material.dart';
import 'package:flutter_application_to_do_app/model/taskmodel.dart';
import 'package:flutter_application_to_do_app/model/usermodel.dart';
import 'package:flutter_application_to_do_app/screen/addtask.dart';
import 'package:flutter_application_to_do_app/screen/mainscreen.dart';
import 'package:flutter_application_to_do_app/service/apiserice.dart';

class HomePage extends StatefulWidget {
  final AuthService _authService = AuthService();

  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    
  }

  Future<void> _loadTasks() async {
    final tasks = await widget._authService.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _deleteTask(Task task) async {
    // Define deleteTask function
    await widget._authService.deleteTask(task);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await widget._authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            FutureBuilder<User?>(
              future: widget._authService.getUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return MainScreen(
                      user: user,
                      tasks: _tasks,
                      loadTasks: _loadTasks,
                      deleteTask: _deleteTask,
                    );
                  } else {
                    return const Center(child: Text('No user data found.'));
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                onAddTask: (task) async {
                  await widget._authService.addTask(task);
                  _loadTasks();
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
