import 'package:flutter/material.dart';
import 'package:flutter_application_to_do_app/model/taskmodel.dart';

class RemainingTime extends StatelessWidget {
  const RemainingTime({
    super.key,
    required this.task,
  });

  final Task task;
  String _formatRemainingTime(DateTime deadline, String need) {
    Duration difference = deadline.difference(DateTime.now());
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    if (need == "d") {
      return days.toString();
    } else if (need == "h") {
      return hours.toString();
    } else {
      return minutes.toString();
    }
  }

  String _addLeadingZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(color: Colors.white30),
          child: Center(
            child: Text(
              _addLeadingZero(
                  int.parse(_formatRemainingTime(task.deadline, "d"))),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Text(
          " D:  ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(color: Colors.white30),
          child: Center(
            child: Text(
              _addLeadingZero(
                  int.parse(_formatRemainingTime(task.deadline, "h"))),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Text(
          " h:  ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(color: Colors.white30),
          child: Center(
            child: Text(
              _addLeadingZero(
                  int.parse(_formatRemainingTime(task.deadline, "m"))),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Text(
          " m",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
