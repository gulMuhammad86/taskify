import 'package:flutter/material.dart';
import 'package:taskify/service/category_service.dart';
import '../model/category.dart';

class CategoriesScreeen extends StatefulWidget {
  const CategoriesScreeen({super.key});

  @override
  State<CategoriesScreeen> createState() => _CategoriesScreeenState();
}

class _CategoriesScreeenState extends State<CategoriesScreeen> {
  final _nameTextController = TextEditingController();
  final _descTextControllor = TextEditingController();
  final _editCategoryNameController = TextEditingController();
  final _editCategoryDescController = TextEditingController();
  final _category = Category();
  final _categoryService = CategoryService();
  final List<Category> _categoryList = <Category>[];

  var category;
  @override
  void initState() {
    super.initState();
    getallCategories();
  }

  _showSuccesSnackBar(BuildContext context, message) {
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  getallCategories() async {
    _categoryList.clear();
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.getItemById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescController.text =
          category[0]['description'] ?? 'no decription';
    });
    showEditFormDialog(context);
  }

  showEditFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("caterory form"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _editCategoryNameController,
                    decoration: const InputDecoration(
                      label: Text("name"),
                      hintText: "write category name",
                    ),
                  ),
                  TextField(
                    controller: _editCategoryDescController,
                    decoration: const InputDecoration(
                      label: Text("description"),
                      hintText: "write category description",
                    ),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal())),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal())),
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryNameController.text;
                  _category.description = _editCategoryDescController.text;
                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    Navigator.pop(context);
                    getallCategories();
                    _showSuccesSnackBar(context, "updated successsfully");
                  }
                },
                child: const Text("update"),
              )
            ],
          );
        });
  }

  showSaveFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("save caterory form"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _nameTextController,
                    decoration: const InputDecoration(
                      label: Text("name"),
                      hintText: "write category name",
                    ),
                  ),
                  TextField(
                    controller: _descTextControllor,
                    decoration: const InputDecoration(
                      label: Text("description"),
                      hintText: "write category description",
                    ),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal())),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("cancel")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal())),
                onPressed: () async {
                  _category.name = _nameTextController.text;
                  _category.description = _descTextControllor.text;
                  var save = await _categoryService.saveCategory(_category);
                  if (save > 0) {
                    Navigator.pop(context);
                    getallCategories();
                  }
                },
                child: const Text("save"),
              )
            ],
          );
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
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(color: Colors.white),
                      backgroundColor: Colors.red,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal())),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("cancel")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.lightBlue,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal())),
                  onPressed: () {
                    _categoryService.deleteCategory(itemId);
                    Navigator.pop(context);
                    getallCategories();
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
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        title: const Text("Categories Screen"),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
          onPressed: () {
            showSaveFormDialog(context);
          }),
      body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(_categoryList[index].name!),
                subtitle: Text(_categoryList[index].description!),
                leading: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _nameTextController.text = _categoryList[index].name!;
                    _descTextControllor.text =
                        _categoryList[index].description!;
                    _editCategory(context, _categoryList[index].id);
                  },
                ),
                trailing: IconButton(
                    onPressed: () {
                      if (_categoryList[index].id != null) {
                        showDeleteDaialog(context, _categoryList[index].id);
                      }
                    },
                    icon: const Icon(Icons.delete)),
              ),
            );
          }),
    );
  }
}
