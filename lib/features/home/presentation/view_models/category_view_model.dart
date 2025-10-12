import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_app/features/home/data/models/category.dart';
import 'package:task_app/features/home/domain/repositories/category_repository.dart';

class CategoryViewModel extends ChangeNotifier {
  Color? selectedColor;
  String? selectedCategory;
  CategoryRepository categoryRepository;
  AuthRepository authRepository;
  CategoryViewModel(
      {required this.categoryRepository, required this.authRepository});
  List<Category> categories = [];
  addCategory(
      {required String categoryName,
      required String categoryDescription,
      required Color color}) async {
    final category = Category(
        name: categoryName, color: color, description: categoryDescription);
    final newCategory = categoryRepository.addCategory(
        await authRepository.getUid(), category, color.toARGB32());
    categories.add(await newCategory);

    notifyListeners();
  }

  void reset() {
    categories.clear();
    selectedCategory = null;
    selectedColor = null;
    notifyListeners();
  }

  void fetchCategories() async {
    categories.clear();
    categories =
        await categoryRepository.fetchCategories(await authRepository.getUid());
    notifyListeners();
  }

  selectColor(Color? color) {
    
    selectedColor = color;
    notifyListeners();
  }

  selectCategory(String? category) {
    selectedCategory = category;
    notifyListeners();
  }

  deleteCategory(Category category) async {
    categories.remove(category);
    categoryRepository.deleteCategory(
        await authRepository.getUid(), category.id!);
    notifyListeners();
  }

  updateCategory(
      {required String newName,
      required String newDecription,
      required String idCategory}) async {
    final updatedCategory = await categoryRepository.updateCategory(
        await authRepository.getUid(), idCategory, newName, newDecription);
    int index = categories.indexWhere(
      (element) => element.id == idCategory,
    );

    if (index != -1) {
      categories[index] = updatedCategory;
    }
    categories.forEach((element) => log('${element.name}'));

    notifyListeners();
  }
}
