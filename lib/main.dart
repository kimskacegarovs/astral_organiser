import 'package:flutter/material.dart';
import 'strings.dart' as strings;
import 'todo/todo_screen.dart';
import 'quantified/widget.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: strings.appName,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage(title: strings.appHeaderTitle));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TodoScreen(),
    const QuantifiedScreen(),
  ];

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Todo'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Quantified'),
            ]));
  }
}
