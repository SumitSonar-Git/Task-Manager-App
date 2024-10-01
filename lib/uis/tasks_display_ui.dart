import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/provider%20service/provider.dart';

class TaskListUI extends StatefulWidget {
  const TaskListUI({super.key});

  @override
  State<TaskListUI> createState() => _TaskListUIState();
}

class _TaskListUIState extends State<TaskListUI> {
  String selectedSort = 'None';
  String selectedPriority = 'All';
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final tasks = provider.tasks;

    void showDeleteDialog(
        BuildContext context, TaskProvider provider, String taskId) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Delete Task",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text("Are you sure you want to delete this task?"),
              actions: [
                TextButton(
                  child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Yes", style: TextStyle(color: Colors.redAccent)),
                  onPressed: () {
                    provider.deleteTask(taskId);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    // Filter tasks based on priority and category
    List filteredTasks = tasks.where((task) {
      if (selectedPriority != 'All' && task.priorities != selectedPriority) {
        return false;
      }
      if (selectedCategory != 'All' && task.categories != selectedCategory) {
        return false;
      }
      return true;
    }).toList();

    // Sort tasks by due date if selected
    if (selectedSort == 'Due Date') {
      filteredTasks.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown menus for sorting and filtering
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedSort,
                    items: ['None', 'Due Date']
                        .map((sort) => DropdownMenuItem(
                              value: sort,
                              child: Text('Sort by $sort'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSort = value!;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedPriority,
                    items: ['All', 'Low', 'Medium', 'High']
                        .map((priority) => DropdownMenuItem(
                              value: priority,
                              child: Text('Priority: $priority'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPriority = value!;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedCategory,
                    items: ['All', 'Work', 'Personal', 'Others']
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text('Category: $category'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredTasks.isEmpty
                  ? Center(
                      child: Text(
                        'No tasks available. Add a new task!',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.description,
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Due Date: ${task.dueDate ?? 'N/A'}',
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete_outline),
                              color: Colors.redAccent,
                              onPressed: () {
                                showDeleteDialog(context, provider, task.id);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
