import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:astral_organiser/todo/main_class.dart';

class TodoRepository {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print("path $path");
    return File('$path/todos.json');
  }

  Future<List<Todo>> readTodos() async {
    final file = await _localFile;
    final contents = await file.readAsString();
    final List<dynamic> todoList = jsonDecode(contents);
    final List<Todo> todos =
        todoList.map((e) => Todo.fromMap(jsonDecode(e))).toList();
    return todos;
  }

  Future<File> writeTodos(List<Todo> todos) async {
    print("writeTodos");
    print(jsonEncode(todos));
    final file = await _localFile;
    return file.writeAsString(jsonEncode(todos));
  }

  Future<File> deleteTodo(List<Todo> todos) async {
    print("delete (replace with new)");
    return writeTodos(todos);
  }
}
