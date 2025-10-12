

import 'package:flutter/material.dart';
import 'package:task_app/core/services/notification_service.dart';
import 'package:task_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_app/features/home/data/models/notification.dart';
import 'package:task_app/features/home/data/models/task.dart';
import 'package:task_app/features/home/domain/repositories/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  bool tasknotificationsEnabled = false;
  List<NotificationApp> notificationsTodayList = [];
  List<NotificationApp> notificationsWeekList = [];
  List<NotificationApp> notificationsYesterdayList = [];
  List<NotificationApp> allNotificationsList = [];
  NotificationRepository notificationRepository;
  AuthRepository authRepository;
  NotificationViewModel(
      {required this.notificationRepository, required this.authRepository});
  void switchTaskNotificationValue(bool val) {
    tasknotificationsEnabled = val;
    notifyListeners();
  }

  void switchNotificationValue(bool val) {
    tasknotificationsEnabled = val;
    notifyListeners();
  }

  void addNotification(
    String userId,
    NotificationApp notification,
  ) async {
    NotificationApp newNotification =
        await notificationRepository.addNotification(userId, notification);
    allNotificationsList.add(newNotification);
    filterNotifications();
    notifyListeners();
  }

  void markAsRead(NotificationApp notification) async {
    final index = allNotificationsList.indexOf(notification);
    if (index != -1) {
      allNotificationsList[index].isRead = true;
    }
    await notificationRepository.markAsRead(
        await authRepository.getUid(), notification.idNotification!);

    notifyListeners();
  }

  void markAsAllRead() async {
    for (var notification in allNotificationsList) {
      final index = allNotificationsList.indexOf(notification);
      allNotificationsList[index].isRead = true;
      await notificationRepository.markAsRead(
          await authRepository.getUid(), notification.idNotification!);
    }

    filterNotifications();

    notifyListeners();
  }

  void removeNotification(NotificationApp notification) async {
    await notificationRepository.removeNotification(
        await authRepository.getUid(), notification.idNotification!);

    allNotificationsList.remove(notification);
    filterNotifications();

    notifyListeners();
  }

  void filterNotifications() async {
    final now = DateTime.now();

    final startOfToday = DateTime(now.year, now.month, now.day);

    final startOfYesterday = startOfToday.subtract(const Duration(days: 1));

    final startOfWeek = startOfToday.subtract(const Duration(days: 7));

    final startOfTomorrow = startOfToday.add(const Duration(days: 1));

    notificationsTodayList = allNotificationsList.where((notification) {
      final ts = notification.timestamp!;
      return ts.isAfter(startOfToday) && ts.isBefore(startOfTomorrow);
    }).toList();

    notificationsYesterdayList = allNotificationsList.where((notification) {
      final ts = notification.timestamp!;
      return ts.isAfter(startOfYesterday) && ts.isBefore(startOfToday);
    }).toList();

    notificationsWeekList = allNotificationsList.where((notification) {
      final ts = notification.timestamp!;
      return ts.isAfter(startOfWeek) && ts.isBefore(startOfYesterday);
    }).toList();

    if (notificationsWeekList.isEmpty &&
        notificationsYesterdayList.isEmpty &&
        notificationsTodayList.isEmpty) {
      allNotificationsList.forEach(
        (notification) async {
          await notificationRepository.removeNotification(
              await authRepository.getUid(), notification.idNotification!);
        },
      );
    }
 
    notifyListeners();
  }

  void fetchNotifications() async {
    notificationsYesterdayList.clear();
    notificationsTodayList.clear();
    notificationsWeekList.clear();
    allNotificationsList.clear();
    List<NotificationApp> notifications = await notificationRepository
        .fetchNotification(await authRepository.getUid());

    allNotificationsList = notifications
        .where(
          (element) => element.type == 'scheduled',
        )
        .toList();
    filterNotifications();

    notifyListeners();
  }

  Future sendNotification(Task task, DateTime date) async {
    if (task.notificationsEnabled && date.isAfter(DateTime.now())) {
      List<int> units = task.id!.codeUnits;
      int idNotification = units.fold(
        0,
        (previousValue, element) => previousValue + element,
      );
      await NotificationService.scheduleNotification(
          id: idNotification,
          title: task.title,
          body: task.description,
          date: task.date);
    }
  }

  void reset() {
    notifyListeners();
  }
}
