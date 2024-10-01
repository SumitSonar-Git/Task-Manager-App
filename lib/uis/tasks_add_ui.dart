import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/provider%20service/provider.dart';
import 'package:task_manager_app/model%20class/taskmodel.dart';
import 'package:intl/intl.dart';

class TasksEditUI extends StatefulWidget {
  const TasksEditUI({super.key});

  @override
  State<TasksEditUI> createState() => _TasksEdituiState();
}

class _TasksEdituiState extends State<TasksEditUI> {
  List<String> priorities_Lists = ['Low', 'Medium', 'High'];
  List<String> categories_Lists = ['Work', 'Personal'];

  String? prio_dropDownValue;
  String? cate_dropDownValue;
  String formattedDate = '';

  TextEditingController customCategoryController = TextEditingController();
  // Add a controller for the due date
  TextEditingController dueDateController = TextEditingController();

  void _showAddCategoryDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add New Category'),
            content: TextField(
              controller: customCategoryController,
              decoration: InputDecoration(
                hintText: 'Enter new category',
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("cancle")),
              TextButton(
                onPressed: () {
                  if (customCategoryController.text.isNotEmpty) {
                    setState(() {
                      categories_Lists.add(customCategoryController.text);
                      cate_dropDownValue = customCategoryController.text;
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Add'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return Scaffold(
        backgroundColor: const Color(0xFFb1decf),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 15),
            child: Container(
              height: 450,
              width: 330,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Add Tasks",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Task',
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Description',
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      value: prio_dropDownValue,
                      decoration: InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      hint: Text('Select Priority Level'), // Placeholder text
                      items: priorities_Lists
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          prio_dropDownValue =
                              newValue ?? 'Select Priority Level';
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      value: cate_dropDownValue, // Ensure null if placeholder
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      hint: Text('Choose Category'), // Placeholder text
                      items: [
                        ...categories_Lists
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        DropdownMenuItem<String>(
                          value: 'Others',
                          child: Text('Others'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue == 'Others') {
                          _showAddCategoryDialog();
                        } else {
                          setState(() {
                            cate_dropDownValue = newValue;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: dueDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: formattedDate.isEmpty
                              ? 'Due Date(Optional)'
                              : 'Selected Date: $formattedDate',
                          hintStyle: TextStyle(fontSize: 18),
                          suffixIcon: Icon(Icons.calendar_today)),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          // Formatting the picked date
                          formattedDate =
                              DateFormat('dd/MM/yyyy').format(pickedDate);
                          setState(() {
                            dueDateController.text =
                                pickedDate.toString().substring(0, 10);
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final title = titleController.text.trim();
                        if (title.isNotEmpty) {
                          final task = Task(
                            id: DateTime.now().toString(),
                            title: titleController.text,
                            description: descriptionController.text,
                            priorities: prio_dropDownValue,
                            categories: cate_dropDownValue,
                            dueDate: dueDateController.text,
                          );
                          provider.addTask(task);
                          titleController.clear();
                          descriptionController.clear();
                          dueDateController.clear();
                          setState(() {
                            prio_dropDownValue = null; // Reset to null
                            cate_dropDownValue = null; // Reset to null
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('$title Task added successfully'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Task feild should not be empty'),
                          ));
                        }
                      },
                      child: Text("Add"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
