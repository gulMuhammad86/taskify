import 'package:taskify/model/todo.dart';
import 'package:taskify/repository/repository.dart';

class TodoService {
  final Repositoy _repositoy;
  TodoService() : _repositoy = Repositoy();

  saveTodo(Todo todo) async {
    return await _repositoy.savTodo("todo", todo.gettodoMap());
  }

  readTodos() async {
    return await _repositoy.readTodoData('todo');
  }

  readTodoByCategory(category) async {
    return await _repositoy.readTodoByCategory("todo", "category", category);
  }

  updateTodo(Todo data) async {
    return await _repositoy.updateData("todo", data.gettodoMap());
  }

  getTodoById(itemId) async {
    return await _repositoy.getItemByID('todo', itemId);
  }

  deletTodo(itemId) async {
    return await _repositoy.deleteCategory('todo', itemId);
  }
}
