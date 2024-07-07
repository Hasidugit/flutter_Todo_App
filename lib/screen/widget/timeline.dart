import 'package:flutter/material.dart';
import 'package:flutter_application_to_do_app/model/taskmodel.dart';
import 'package:flutter_application_to_do_app/service/apiserice.dart';

class EasyDateTimeLine extends StatelessWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChange;
  final AuthService authService; // Inject AuthService instance
  final BoxDecoration Function(DateTime date, bool isSelected, bool hasDueDate)
      dayDecoration;

  const EasyDateTimeLine({
    super.key,
    required this.initialDate,
    required this.onDateChange,
    required this.authService,
    required this.dayDecoration,
  });

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    int currentMonth = initialDate.month;
    bool showMonth = true;

    return FutureBuilder<List<Task>>(
      future: authService.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching tasks'));
        } else {
          List<Task> tasks = snapshot.data ?? [];

          return SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 30,
              itemBuilder: (context, index) {
                DateTime currentDate = initialDate.add(Duration(days: index));
                bool isSelected =
                    false; // Replace with actual logic for selection

                bool hasDueDate =
                    tasks.any((task) => _isSameDay(task.deadline, currentDate));

                BoxDecoration decoration =
                    dayDecoration(currentDate, isSelected, hasDueDate);

                // Check if currentDate is today
                if (_isSameDay(currentDate, today)) {
                  decoration = BoxDecoration(
                    color: const Color.fromARGB(
                        255, 212, 198, 90), // Change color to yellow for today
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasDueDate ? Colors.red : Colors.black,
                      width: 2,
                    ),
                  );
                }

                // Check if we need to display the month
                if (currentDate.month != currentMonth) {
                  currentMonth = currentDate.month;
                  showMonth = true;
                } else {
                  showMonth = false;
                }

                return GestureDetector(
                  onTap: () {
                    onDateChange(currentDate);
                    _showTasksDialog(context, tasks, currentDate);
                  },
                  child: Container(
                    width: 60, // Adjust width to accommodate both texts
                    margin: const EdgeInsets.all(8),
                    decoration: decoration,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showMonth || hasDueDate)
                          Text(
                            _getMonthName(currentDate.month),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 245, 242, 242),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        Text(
                          '${currentDate.day}',
                          style: TextStyle(
                            color: hasDueDate
                                ? const Color.fromARGB(255, 227, 218, 218)
                                : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getWeekdayName(currentDate.weekday),
                          style: TextStyle(
                            color: hasDueDate
                                ? const Color.fromARGB(255, 227, 218, 218)
                                : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case DateTime.january:
        return 'January';
      case DateTime.february:
        return 'February';
      case DateTime.march:
        return 'March';
      case DateTime.april:
        return 'April';
      case DateTime.may:
        return 'May';
      case DateTime.june:
        return 'June';
      case DateTime.july:
        return 'July';
      case DateTime.august:
        return 'August';
      case DateTime.september:
        return 'September';
      case DateTime.october:
        return 'October';
      case DateTime.november:
        return 'November';
      case DateTime.december:
        return 'December';
      default:
        return '';
    }
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thur';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _showTasksDialog(BuildContext context, List<Task> tasks, DateTime date) {
    List<Task> tasksForDate =
        tasks.where((task) => _isSameDay(task.deadline, date)).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tasks for ${_getMonthName(date.month)} ${date.day}'),
          content: tasksForDate.isEmpty
              ? const Text('No tasks for this date')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: tasksForDate.map((task) {
                    return Card(
                      elevation: 2, // Add elevation for a shadow effect
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Optional: Round card corners
                      ),
                      child: Center(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 10,
                            backgroundColor: task.color,
                          ),
                          title: Text(
                            task.title,
                            maxLines: 2,
                          ),
                          subtitle: Text(
                            task.description,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
