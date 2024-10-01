import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/provider%20service/provider.dart';
import 'package:task_manager_app/uis/tasks_add_ui.dart';
import 'package:task_manager_app/uis/tasks_display_ui.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;

  void onTapIndexed(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
void initState() {
  super.initState();
  // Load tasks using the TaskProvider from the context
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  });
}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Task Manager",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: const Color(0xFFb1decf),
        body: IndexedStack(
          index: selectedIndex,
          children: const <Widget>[TaskListUI(), TasksEditUI()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: const Color(0xFFb1decf),
          // Set the background color of the entire BottomNavigationBar
          selectedItemColor: Colors.black, // Color for the selected item
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                color: Colors.black,
              ),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
                backgroundColor: const Color(0xFFb1decf),
                icon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
                label: 'Add')
          ],
          currentIndex: selectedIndex,
          onTap: onTapIndexed,
          // selectedItemColor: Colors.black,
        ),
      ),
    );
  }
}
