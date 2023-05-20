import 'dart:io';

import 'package:astral_organiser/todo/main_class.dart';
import 'package:astral_organiser/utils.dart';

class TodoRepository {
  final String fileName = "todos.json";
  late final Repository<Todo> repository;

  TodoRepository() {
    repository = Repository<Todo>(fileName);
  }

  Future<List<Todo>> readTodos() => repository.readData(Todo.fromMap);

  Future<File> writeTodos(List<Todo> todos) => repository.writeData(todos);

  Future<File> deleteTodo(List<Todo> todos) => repository.deleteData(todos);
}
