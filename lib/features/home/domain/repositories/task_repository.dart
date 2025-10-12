import 'package:task_app/features/home/data/models/category.dart';
import 'package:task_app/features/home/data/models/task.dart';

abstract class TaskRepository {
  Future<Task> addTasks(String uid, Task task);
  Future removeTasks(String uidUser, String taskId);
  Future fetchTasks(String uidUser);
  Future updateCategoryTasks(String uidUser, Category category, List<Task> tasks);
  Future updateTask(String uidUser, Task task ,String taskId );
}
