import 'package:flutter/material.dart';
import 'strings.dart' as strings;
import 'todo/todo_screen.dart';

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
  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) => const TodoScreen();
}
