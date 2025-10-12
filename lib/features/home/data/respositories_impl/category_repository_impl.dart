
import 'package:task_app/features/home/data/datasources/category_remote_data_source.dart';
import 'package:task_app/features/home/data/models/category.dart';
import 'package:task_app/features/home/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  CategoryRemoteDataSource categoryRemoteDataSource =
      CategoryRemoteDataSource();
  Future addCategory(String userId, Category category, int colorVal) {
    return categoryRemoteDataSource.addCategory(userId, category, colorVal);
  }

  @override
  Future fetchCategories(String userId ) {
    return categoryRemoteDataSource.fetchCategories(userId );
  }
  
  @override
  Future deleteCategory(String userId, String idCategory) {
  return categoryRemoteDataSource.deleteCategory(userId, idCategory) ; 
  }
  @override
  Future <Category>updateCategory(String userId, String idCategory , String newName , String newDescription) {
  return categoryRemoteDataSource.updateCategory(userId, idCategory , newName , newDescription) ; 
  }
}
