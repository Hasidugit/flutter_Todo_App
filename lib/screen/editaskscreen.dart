import 'package:flutter/material.dart';
import 'package:flutter_application_to_do_app/model/taskmodel.dart';
import 'package:flutter_application_to_do_app/service/apiserice.dart'; // Assuming this is the correct path to AuthService

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _deadline;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _deadline = widget.task.deadline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Task',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (_titleController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a title'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              Task updatedTask = Task(
                title: _titleController.text,
                description: _descriptionController.text,
                deadline: _deadline,
                isComplete: widget.task.isComplete,
                color: widget.task.color,
              );

              await AuthService().updateTask(updatedTask);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pop(context, updatedTask);
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                hintText: 'Enter task title',
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                hintText: 'Enter task description',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Deadline: ${_deadline.month}/${_deadline.day}/${_deadline.year}',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _deadline,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != _deadline) {
                      setState(() {
                        _deadline = picked;
                      });
                    }
                  },
                  child: Text('Select Deadline'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
