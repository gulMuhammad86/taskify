import 'package:flutter/material.dart';
import 'package:taskify/helpers/app_nav_drawer.dart';
import 'package:taskify/model/todo.dart';
import 'package:taskify/service/category_service.dart';
import 'package:taskify/service/todo_services.dart';
import '../screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  // final String category;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var todoList = <Todo>[];
  var todoService = TodoService();
  final _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    setState(() {
      todoList.clear();
    });

    var todos = await todoService.readTodos();

    todos.forEach((category) {
      var model = Todo();
      setState(() {
        model.name = category['name'];
        model.description = category['description'];
        model.date = category['date'];
        model.isfinished = category['isfinished'];
        model.id = category['id'];
        todoList.add(model);
      });
    });
  }

  showDeleteDaialog(BuildContext context, itemId) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Are you sure you want to delete?"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("cancel")),
              ElevatedButton(
                  onPressed: () {
                    _categoryService.deleteCategory(itemId);
                    Navigator.pop(context);
                    getAllTodos();
                  },
                  child: const Text("yes"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlue,
        title: const Text("todo list"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      drawer: const AppNavDrawer(),
      drawerScrimColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TodoScreen(getTodos: getAllTodos),
          ),
        ),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            final item = todoList[index].id;
            return Dismissible(
              onDismissed: (direction) async {
                await todoService.deletTodo(todoList[index].id);
                setState(() {
                  getAllTodos();
                });
                // Then show a snackbar.
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('$item dismissed')));
              },
              key: Key(item.toString()),
              child: Card(
                child: ListTile(
                    subtitle: Text(todoList[index].description!),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(todoList[index].name!),
                        Text(todoList[index].date!)
                      ],
                    ),
                    trailing: Checkbox(
                        value: todoList[index].isfinished == 0 ? false : true,
                        onChanged: (value) async {
                          if (value == true) {
                            todoList[index].isfinished = 1;
                          } else {
                            todoList[index].isfinished = 0;
                          }

                          var res =
                              await todoService.updateTodo(todoList[index]);
                          if (res > 0) {
                            // getAllTodos();
                          }
                        })),
              ),
            );
          }),
    );
  }
}
