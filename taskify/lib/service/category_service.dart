import 'package:taskify/model/category.dart';
import 'package:taskify/repository/repository.dart';

class CategoryService {
  Repositoy repositry;

  CategoryService() : repositry = Repositoy();

  saveCategory(Category category) async {
    return await repositry.insertData("categories", category.categoryMap());
  }

  readCategory() async {
    return await repositry.readData("categories");
  }

  updateCategory(Category category) async {
    return await repositry.updateData("categories", category.categoryMap());
  }

  deleteCategory(itemId) async {
    return await repositry.deleteCategory("categories", itemId);
  }

  getItemById(itemId) async {
    return await repositry.getItemByID("categories", itemId);
  }
}
