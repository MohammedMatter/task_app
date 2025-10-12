import 'package:task_app/features/home/data/models/notification.dart';
abstract class NotificationRepository {
  Future<NotificationApp> addNotification(String userId, NotificationApp notification);
  Future<void> removeNotification(String userId,  String notificationId);
  Future<List<NotificationApp>> fetchNotification(String userId);
  Future<void> markAsRead(String userId , String notificationId);
}
