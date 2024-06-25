import 'package:flutter/material.dart';
import 'package:taskify/model/todo.dart';
import 'package:taskify/service/todo_services.dart';

class TodoWtihCategory extends StatefulWidget {
  const TodoWtihCategory({super.key, required this.todoCategory});

  final String todoCategory;
  @override
  State<TodoWtihCategory> createState() => _TodoWtihCategoryState();
}

class _TodoWtihCategoryState extends State<TodoWtihCategory> {
  var _todoService = TodoService();

  var _listedtodos = <Todo>[];
  var model = Todo();

  @override
  void initState() {
    super.initState();
    getTodosByCategory();
  }

  getTodosByCategory() async {
    var todos = await _todoService.readTodoByCategory(widget.todoCategory);
    todos.forEach((element) {
      setState(() {
        model.name = element['name'];
        model.description = element['description'];
        model.date = element['date'];
        _listedtodos.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("todos by category"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _listedtodos.length,
        itemBuilder: ((context, index) => Card(
              child: ListTile(
                title: Text(_listedtodos[index].name!),
                subtitle: Text(_listedtodos[index].description!),
                trailing: Text(_listedtodos[index].date!),
              ),
            )),
      ),
    );
  }
}
