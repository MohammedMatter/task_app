
import 'package:task_app/features/home/data/models/category.dart';
abstract class CategoryRepository {
  Future addCategory(String userId , Category category , int colorVal);
  Future fetchCategories(String userId);
  Future deleteCategory(String userId , String idCategory);
  Future <Category>updateCategory(String userId , String idCategory,String newName , String newDecription);
} 