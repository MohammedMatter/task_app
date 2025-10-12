import 'package:task_app/features/home/data/datasources/task_remote_data_source.dart';
import 'package:task_app/features/home/data/models/category.dart';
import 'package:task_app/features/home/data/models/task.dart';
import 'package:task_app/features/home/domain/repositories/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {
  TaskRemoteDataSource taskRemoteDataSource;
  TaskRepositoryImpl({required this.taskRemoteDataSource});
  @override
  Future<Task> addTasks(String uid, Task task) async {
    return await taskRemoteDataSource.addTasks(uid, task);
  }

  @override
  Future removeTasks(String uidUser, String taskId) async {
    return await taskRemoteDataSource.removeTasks(uidUser, taskId);
  }

  @override
  Future fetchTasks(String uidUser) async {
    return await taskRemoteDataSource.fetchTasks(uidUser);
  }

  @override
  Future updateCategoryTasks(
      String uidUser, Category category, List<Task> tasks) async {
    return await taskRemoteDataSource.updateCategoryTasks(
        uidUser, category, tasks);
  }

  @override
  Future updateTask(String uidUser, Task task, String taskId) async {
    return await taskRemoteDataSource.updateTask(uidUser, taskId,task );
  }
}
