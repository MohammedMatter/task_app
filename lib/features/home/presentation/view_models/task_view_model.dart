import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:task_app/core/services/notification_service.dart';
import 'package:task_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_app/features/home/data/models/task.dart';
import 'package:task_app/features/home/domain/repositories/notification_repository.dart';
import 'package:task_app/features/home/domain/repositories/task_repository.dart';
import 'package:task_app/features/home/presentation/view_models/notification_view_model.dart';
import 'package:task_app/features/user/domain/repositories/user_repository.dart';
import '../../data/models/category.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> upcomingTasks = [];
  List<Task> inProgressTasks = [];
  List<Task> doneTasks = [];
  List<Task> allTasks = [];
  List<Task> filterTasksSearch = [];
  DateTime? selectedTime;
  TaskRepository taskRepository;
  AuthRepository authRepository;
  NotificationRepository notificationRepository;
  UserRepository userRepository;

  TaskViewModel(
      {required this.notificationRepository,
      required this.taskRepository,
      required this.authRepository,
      required this.userRepository});
  void reset() {
    upcomingTasks.clear();
    inProgressTasks.clear();
    doneTasks.clear();
    allTasks.clear();
    selectedTime = null;
    notifyListeners();
  }

  void fetchData() async {
    List<Task> tasks =
        await taskRepository.fetchTasks(await authRepository.getUid());
    upcomingTasks.clear();
    inProgressTasks.clear();
    doneTasks.clear();
    allTasks.clear();
    for (var task in tasks) {
      if (task.statusName == 'InProgress') {
        inProgressTasks.add(task);
      }
      if (task.statusName == 'Done') {
        doneTasks.add(task);
      }
      if (task.statusName == 'UpComing') {
        log('${task.category.color}');
        upcomingTasks.add(task);
      }
    }
    allTasks
      ..addAll(upcomingTasks)
      ..addAll(inProgressTasks)
      ..addAll(doneTasks);

    notifyListeners();
  }

  void addToUpcomingTasks(
      {required String title,
      required String description,
      required DateTime date,
      required Category category,
      required String status,
      required bool notificationEnabled,
      required DateTime createdAt,
      required NotificationViewModel prov}) async {
    Task task = Task(
        createdAt: createdAt,
        notificationsEnabled: notificationEnabled,
        category: category,
        date: date,
        description: description,
        title: title,
        statusName: status,
        statusColor: Colors.blue);
    final newTask =
        await taskRepository.addTasks(await authRepository.getUid(), task);
    allTasks.clear();
    upcomingTasks.add(newTask);
    userRepository.addUser(
      await authRepository.getEmail(),
      await authRepository.getUid(),
    );

    await prov.sendNotification(newTask, selectedTime!);
    addAllTasks(upcomingTasks, inProgressTasks, doneTasks);
    selectTime(null);
    notifyListeners();
  }

  void addToInProgressTasks(
      {required String title,
      required String description,
      required DateTime date,
      required Category category,
      required String status,
      required bool notificationsEnabled,
      required DateTime createdAt}) async {
    allTasks.clear();
    Task task = Task(
        createdAt: createdAt,
        notificationsEnabled: notificationsEnabled,
        category: category,
        date: date,
        description: description,
        title: title,
        statusName: status,
        statusColor: Colors.orange);
    final newTask =
        await taskRepository.addTasks(await authRepository.getUid(), task);
    inProgressTasks.add(newTask);

    addAllTasks(upcomingTasks, inProgressTasks, doneTasks);
    notifyListeners();
  }

  void addToDoneTasks(
      {required String title,
      required String description,
      required DateTime date,
      required Category category,
      required String status,
      required bool notificationsEnabled,
      required DateTime createdAt}) async {
    allTasks.clear();
    Task task = Task(
        createdAt: createdAt,
        notificationsEnabled: notificationsEnabled,
        category: category,
        date: date,
        description: description,
        title: title,
        statusName: status,
        statusColor: Colors.green);
    final newTask =
        await taskRepository.addTasks(await authRepository.getUid(), task);
    doneTasks.add(newTask);

    addAllTasks(upcomingTasks, inProgressTasks, doneTasks);

    notifyListeners();
  }

  void addAllTasks(List<Task> upcomingTasks, List<Task> inProgressTasks,
      List<Task> doneTasks) {
    allTasks
      ..addAll(upcomingTasks)
      ..addAll(inProgressTasks)
      ..addAll(doneTasks);

    notifyListeners();
  }

  void selectTime(DateTime? time) {
    selectedTime = time;

    notifyListeners();
  }

  void deleteTask(Task task) async {
    List<int> units = task.id!.codeUnits;
    int idNotification = units.fold(
      0,
      (previousValue, element) => previousValue + element,
    );
    taskRepository.removeTasks(await authRepository.getUid(), task.id!);
    if (task.statusName == 'InProgress') {
      inProgressTasks.remove(task);

      await NotificationService.cancelScheduleNotification(id: idNotification);

      allTasks.remove(task);
    }
    if (task.statusName == 'Done') {
      doneTasks.remove(task);
      allTasks.remove(task);

      await NotificationService.cancelScheduleNotification(id: idNotification);
    }
    if (task.statusName == 'UpComing') {
      upcomingTasks.remove(task);
      allTasks.remove(task);

      await NotificationService.cancelScheduleNotification(id: idNotification);
    }
    notifyListeners();
  }

  void updateCategoryTasks({
    required String name,
    required Color color,
    required String description,
    required List<Task> tasks,
  }) async {
    Category newCategory =
        Category(name: name, color: color, description: description);

    await taskRepository.updateCategoryTasks(
        await authRepository.getUid(), newCategory, tasks);

    for (var element in tasks) {
      if (element.statusName == 'UpComing') {
        int index = upcomingTasks.indexOf(element);
        upcomingTasks[index].category = newCategory;
      }
      if (element.statusName == 'InProgress') {
        int index = inProgressTasks.indexOf(element);
        inProgressTasks[index].category = newCategory;
      }
      if (element.statusName == 'Done') {
        int index = doneTasks.indexOf(element);
        doneTasks[index].category = newCategory;
      }
    }
    notifyListeners();
  }

  void updateTask(Task task) async {
    await taskRepository.updateTask(
      await authRepository.getUid(),
      task,
      task.id!,
    );
    for (var element in allTasks) {
      if (element.statusName == 'UpComing' && task.id == element.id) {
        int index = upcomingTasks.indexOf(element);

        upcomingTasks[index].title = task.title;
        upcomingTasks[index].description = task.description;
        upcomingTasks[index].date = selectedTime!;
      }
      if (element.statusName == 'InProgress' && task.id == element.id) {
        int index = inProgressTasks.indexOf(element);
        inProgressTasks[index].title = task.title;
        inProgressTasks[index].description = task.description;
        inProgressTasks[index].date = selectedTime!;
      }
      if (element.statusName == 'Done' && task.id == element.id) {
        int index = doneTasks.indexOf(element);
        doneTasks[index].title = task.title;
        doneTasks[index].date = selectedTime!;
        doneTasks[index].description = task.description;
      }
    }
    notifyListeners();
  }
}
