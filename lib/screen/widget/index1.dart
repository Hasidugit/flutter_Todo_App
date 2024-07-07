import 'package:flutter/material.dart';
import 'package:flutter_application_to_do_app/screen/mainscreen.dart';

class Index1 extends StatelessWidget {
  const Index1({
    super.key,
    required this.widget,
    required int selectedTabIndex,
  }) : _selectedTabIndex = selectedTabIndex;

  final MainScreen widget;
  final int _selectedTabIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          final task = widget.tasks[index];
          if (_selectedTabIndex == 0 ||
              (_selectedTabIndex == 1 && task.isComplete)) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 15,
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
                    Container(
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
                ), // Access the title of the task
                subtitle: Text(
                  task.description,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else {
            // Hide incomplete tasks when viewing completed tasks
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
