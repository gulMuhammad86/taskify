import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskify/model/todo.dart';
import 'package:taskify/service/category_service.dart';
import 'package:taskify/service/todo_services.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key, required this.getTodos});

  final Function getTodos;
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _dateTime = DateTime.now();
  final _categories = <DropdownMenuItem>[
    const DropdownMenuItem(value: "no-category", child: Text("no-category"))
  ];
  String? _selectedCategory;
  var todoService = TodoService();
  var model = Todo();
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _showSuccesSnackBar(BuildContext context, message) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _loadCategories() async {
    var categoryService = CategoryService();
    final categoryList = await categoryService.readCategory();
    if (categoryList != null) {
      categoryList.forEach((element) {
        setState(() {
          _categories.add(DropdownMenuItem(
            child: Text(element['name']),
            value: element['name'],
          ));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: const Text("Create Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "name",
                    hintText: "write name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "description",
                    hintText: "write description",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    label: const Text("Date"),
                    prefixIcon: InkWell(
                      child: const Icon(Icons.calendar_today),
                      onTap: () {
                        _showDateTimePicker(context);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                    items: _categories,
                    value: _selectedCategory,
                    hint: const Text("select category"),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal())),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        model.name = _titleController.text;
                        model.description = _descriptionController.text;
                        model.date = _dateController.text;
                        model.category = _selectedCategory.toString();

                        var res = await todoService.saveTodo(model);
                        if (res > 0) {
                          Navigator.of(context).pop();
                          widget.getTodos();
                          _showSuccesSnackBar(
                              context, "todo  saved successfully");
                        }
                      }
                    },
                    child: const Text(
                      "save",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDateTimePicker(BuildContext context) async {
    var pickedDated = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (pickedDated != null) {
      setState(() {
        _dateTime = pickedDated;
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDated);
      });
    }
  }
}
