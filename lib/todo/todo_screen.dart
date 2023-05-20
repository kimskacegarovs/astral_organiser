import 'package:flutter/material.dart';
import 'package:astral_organiser/todo/repository.dart';
import 'package:astral_organiser/todo/main_class.dart';
import 'package:astral_organiser/todo/todo_priority.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  TodoScreenState createState() => TodoScreenState();
}

class TodoScreenState extends State<TodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<Todo> _todos = [];
  bool _isExpandedAddTodo = false;
  bool _isExpandedCompleteTodos = false;
  bool _isExpandedActiveTodos = true;
  TodoPriority _selectedPriority = TodoPriority.low;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    var todos = await TodoRepository().readTodos();
    setState(() => _todos.addAll(todos));
  }

  void _addTodo() {
    final newTodo = Todo(
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: false,
      priority: _selectedPriority,
    );
    setState(() => _todos.add(newTodo));
    _titleController.clear();
    _descriptionController.clear();
    TodoRepository().writeTodos(_todos);
  }

  Widget _buildAddTodo() {
    const header = ListTile(
        title: Text('Add a new todo:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));

    DropdownButtonFormField<TodoPriority> priorityDropdown() {
      return DropdownButtonFormField<TodoPriority>(
        value: _selectedPriority,
        onChanged: (value) {
          setState(() => _selectedPriority = value!);
        },
        items: TodoPriority.values.map((priority) {
          return DropdownMenuItem<TodoPriority>(
              value: priority, child: Text(priority.stringValue));
        }).toList(),
        decoration: const InputDecoration(hintText: 'Priority'),
      );
    }

    var panelBody = Column(
      children: [
        TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: 'Title')),
        TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(hintText: 'Description')),
        priorityDropdown(),
        ElevatedButton(
            onPressed: () => _addTodo(), child: const Text('Add Todo')),
      ],
    );

    return SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(8.0),
            child: ExpansionPanelList(
                elevation: 1,
                expandedHeaderPadding: EdgeInsets.zero,
                dividerColor: Colors.grey,
                children: [
                  ExpansionPanel(
                      headerBuilder: (context, isExpanded) => header,
                      body: panelBody,
                      isExpanded: _isExpandedAddTodo,
                      canTapOnHeader: true)
                ],
                expansionCallback: (panelIndex, isExpanded) {
                  setState(() => _isExpandedAddTodo = !isExpanded);
                })));
  }

  Widget _buildTodoList({bool active = true}) {
    final todos = _todos.where((todo) => todo.isCompleted != active).toList();
    todos.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    if (todos.isEmpty) return const Center(child: Text('No todos'));

    void todoChangeState(Todo todo, value) {
      setState(
          () => {todo.isCompleted = value!, todo.modifiedAt = DateTime.now()});
      TodoRepository().writeTodos(_todos);
    }

    void deleteTodo(Todo todo) {
      setState(() => _todos.removeWhere((t) => t == todo));
      TodoRepository().writeTodos(_todos);
    }

    Widget buildTodoItem(Todo todo) {
      return ListTile(
          leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (value) => todoChangeState(todo, value)),
          title: Text(todo.title),
          subtitle: Text(todo.description),
          trailing: SizedBox(
              width: 200,
              child: Row(children: [
                Icon(todo.priority.iconData, color: todo.priority.iconColor),
                TextButton(
                    onPressed: () => deleteTodo(todo),
                    child: const Icon(Icons.delete))
              ])));
    }

    Widget listViewBuilder = ListView.separated(
      itemCount: todos.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final todo = todos[index];

        dynamic datetimeToDate(DateTime? dt) {
          if (dt == null) return null;
          return DateTime(dt.year, dt.month, dt.day);
        }

        final isDifferentDate = index > 0 &&
            datetimeToDate(todos[index - 1].modifiedAt) !=
                datetimeToDate(todo.modifiedAt);

        return isDifferentDate
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ListTile(
                    title: Text(datetimeToDate(todo.modifiedAt).toString())),
                buildTodoItem(todo)
              ])
            : buildTodoItem(todo);
      },
    );

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return FractionallySizedBox(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200.0),
              child: SizedBox(
                height: constraints.maxHeight,
                child: listViewBuilder,
              )));
    });
  }

  Widget _buildTodoListPanel({bool active = true}) {
    bool stateIsExpanded =
        active ? _isExpandedActiveTodos : _isExpandedCompleteTodos;

    String headerText = active ? "Active todos" : "Completed todos";
    Widget header =
        Padding(padding: const EdgeInsets.all(3.0), child: Text(headerText));

    return ExpansionPanelList(
      elevation: 4,
      expandedHeaderPadding: EdgeInsets.zero,
      dividerColor: Colors.grey,
      children: [
        ExpansionPanel(
            headerBuilder: (context, isExpanded) => header,
            body: _buildTodoList(active: active),
            isExpanded: stateIsExpanded,
            canTapOnHeader: true)
      ],
      expansionCallback: (panelIndex, isExpandedNewVal) {
        setState(() => {
              if (active)
                {_isExpandedActiveTodos = !isExpandedNewVal}
              else
                {_isExpandedCompleteTodos = !isExpandedNewVal}
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Todo List')),
        body: SingleChildScrollView(
          child: Stack(children: [
            buildSingleChildScrollView(),
          ]),
        ));
  }

  SingleChildScrollView buildSingleChildScrollView() {
    return SingleChildScrollView(
      child: Column(children: [
        _buildTodoListPanel(active: true),
        _buildTodoListPanel(active: false),
        _buildAddTodo(),
      ]),
    );
  }
}
