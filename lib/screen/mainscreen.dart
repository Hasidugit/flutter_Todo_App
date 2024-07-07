import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_to_do_app/model/taskmodel.dart';
import 'package:flutter_application_to_do_app/model/usermodel.dart';
import 'package:flutter_application_to_do_app/screen/editaskscreen.dart';
import 'package:flutter_application_to_do_app/screen/widget/index1.dart';
import 'package:flutter_application_to_do_app/screen/widget/remainngtime.dart';
import 'package:flutter_application_to_do_app/screen/widget/timeline.dart';
import 'package:flutter_application_to_do_app/service/apiserice.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:logger/logger.dart';

class MainScreen extends StatefulWidget {
  final User user;
  final List<Task> tasks;
  final Function loadTasks;
  final Function deleteTask;

  const MainScreen(
      {super.key,
      required this.user,
      required this.tasks,
      required this.loadTasks,
      required this.deleteTask});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTabIndex = 0;
  late List<Task> _sortedTasks;

  @override
  void initState() {
    super.initState();
    _sortedTasks = List<Task>.from(widget.tasks);
    _sortedTasks.sort((task1, task2) {
      Duration remainingTimeTask1 = task1.deadline.difference(DateTime.now());
      Duration remainingTimeTask2 = task2.deadline.difference(DateTime.now());
      return remainingTimeTask1.compareTo(remainingTimeTask2);
    });
  }

  Future<void> _toggleTaskCompletion(Task task, bool? value) async {
    setState(() {
      task.isComplete = value ?? false;
    });
    await AuthService().updateTaskCompletionStatus(
        task.title, task.description, task.isComplete);
    await widget.loadTasks();
  }

  String _formatRemainingTime(DateTime deadline) {
    Duration difference = deadline.difference(DateTime.now());
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;

    return " $days D : ${_addLeadingZero(hours)}h : ${_addLeadingZero(minutes)}m";
  }

  String _addLeadingZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  void _updateTask(Task updatedTask) {
    setState(() {
      Logger().f("_uptask");
      final index = _sortedTasks.indexWhere((task) =>
          task.title == updatedTask.title &&
          task.description == updatedTask.description);
      if (index != -1) {
        _sortedTasks[index] = updatedTask;
      }
    });
  }

  bool _hasTasksDueOn(DateTime date) {
    return _sortedTasks.any((task) =>
        task.deadline.year == date.year &&
        task.deadline.month == date.month &&
        task.deadline.day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "image/to_do_background.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: translate(height, width),
          ),
        ),
      ),
    );
  }

  List<Widget> translate(double height, double width) {
    return index2(height, width);
  }

  List<Widget> index2(double height, double width) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          'Hello!, ${widget.user.username}',
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      SizedBox(
        height: height * 0.133,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EasyDateTimeLine(
              initialDate: DateTime
                  .now(), // Example initial date, replace with your logic
              onDateChange: (DateTime selectedDate) {
                // Handle date change logic here
                print('Selected date: $selectedDate');
              },
              authService:
                  AuthService(), // Replace with your AuthService instance
              dayDecoration: (DateTime date, bool isSelected, bool hasDueDate) {
                // Replace with your decoration logic based on date, isSelected, and hasDueDate
                return BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: hasDueDate
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : Colors.black,
                    width: 2,
                  ),
                );
              },
            )
          ],
        ),
      ),
      SizedBox(
        height: height * 0.31,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: _sortedTasks.length,
          itemBuilder: (context, index) {
            final task = _sortedTasks[index];
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: width * 0.6,
                height: height * 0.28,
                child: GlassContainer(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      task.color,
                      const Color.fromARGB(255, 210, 212, 206).withOpacity(0.10)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderGradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.60),
                      Colors.white.withOpacity(0.10),
                      const Color.fromARGB(255, 246, 248, 249)
                          .withOpacity(0.05),
                      const Color.fromARGB(255, 78, 135, 162).withOpacity(0.6)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.39, 0.40, 1.0],
                  ),
                  blur: 0.50,
                  borderWidth: 1.5,
                  elevation: 1.0,
                  isFrostedGlass: false,
                  shadowColor: Colors.black.withOpacity(0.20),
                  alignment: Alignment.center,
                  frostedOpacity: 0.12,
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.all(4.0),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 17,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: task.color,
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  size: 15,
                                  color: Color.fromARGB(255, 6, 4, 4)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title:
                                          const Text("Do You Want To Delete ?"),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("No"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await widget.deleteTask(task);
                                                Navigator.pop(
                                                    context); // Close the dialog
                                                // Close the AddTaskScreen
                                              },
                                              child: const Text("Ok"),
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  size: 15,
                                  color: Color.fromARGB(255, 6, 4, 4)),
                              onPressed: () async {
                                Task updatedTask = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditTaskScreen(task: task),
                                  ),
                                );
                                setState(() {
                                  _updateTask(updatedTask);
                                });
                              },
                            ),
                          ],
                        ),
                        Text(
                          maxLines: 2,
                          'Title:${task.title}',
                          style: const TextStyle(
                            fontSize: 13,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          task.description,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 11,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Complete:",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Transform.scale(
                              scale: 1.0,
                              child: Checkbox(
                                splashRadius: 10,
                                value: task.isComplete,
                                onChanged: (bool? value) async {
                                  await _toggleTaskCompletion(task, value);
                                },
                              ),
                            )
                          ],
                        ),
                        Text(
                          maxLines: 1,
                          "Due date  :${task.deadline.day}/${task.deadline.month}/${task.deadline.year}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (!task.isComplete)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Remaining Time",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RemainingTime(task: task)
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const Divider(
        color: Colors.white,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = 0;
              });
            },
            child: Container(
              width: width * 0.3,
              height: height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _selectedTabIndex == 0 ? Colors.blue : Colors.blueGrey,
              ),
              child: const Center(child: Text("All")),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = 1;
              });
            },
            child: Container(
              width: width * 0.3,
              height: height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _selectedTabIndex == 1 ? Colors.blue : Colors.blueGrey,
              ),
              child: const Center(child: Text("Completed")),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = 2;
              });
            },
            child: Container(
              width: width * 0.3,
              height: height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _selectedTabIndex == 2 ? Colors.blue : Colors.blueGrey,
              ),
              child: const Center(child: Text("Not Complete")),
            ),
          ),
        ],
      ),
      if (_selectedTabIndex == 0)
        Expanded(
          child: ListView.builder(
            itemCount: _sortedTasks.length,
            itemBuilder: (context, index) {
              final task = _sortedTasks[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 15,
                      backgroundColor: task.color,
                    ),
                    title: Row(
                      children: [
                        Text(
                          task.title,
                          maxLines: 1,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        task.isComplete == false
                            ? Text(
                                " ${_formatRemainingTime(task.deadline)}",
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold),
                              )
                            : Container(
                                color: Colors.red,
                                child: const Text(
                                  " Compeleted ",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromARGB(255, 236, 236, 236),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ],
                    ),
                    subtitle: Text(task.description),
                  ),
                ),
              );
            },
          ),
        )
      else if (_selectedTabIndex == 1)
        Index1(widget: widget, selectedTabIndex: _selectedTabIndex)
      else if (_selectedTabIndex == 2)
        Expanded(
          child: ListView.builder(
            itemCount: _sortedTasks.length,
            itemBuilder: (context, index) {
              final task = _sortedTasks[index];
              if ((_selectedTabIndex == 2 && task.isComplete == false)) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: task.color,
                    ),
                    title: Row(
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        task.isComplete == false
                            ? Text(
                                " ${_formatRemainingTime(task.deadline)}",
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              )
                            : const Text(""),
                      ],
                    ),
                    subtitle: Text(
                      task.description,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
    ];
  }

  List<Task> getCompletedTasks() {
    return widget.tasks.where((task) => task.isComplete).toList();
  }
}
