import 'package:task_app/features/home/data/datasources/notification_remote_data_source.dart';
import 'package:task_app/features/home/data/models/notification.dart';
import 'package:task_app/features/home/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  NotificationRemoteDataSource notificationRemoteDataSource =
      NotificationRemoteDataSource();
  @override
  Future<NotificationApp> addNotification(String UserId, NotificationApp notification  ) {
    return notificationRemoteDataSource.addNotification(UserId, notification  );
  }
  
  @override
  Future<List<NotificationApp>> fetchNotification(String userId) {

    return  notificationRemoteDataSource.fetchNotification(userId);
  }
  
  @override
  Future<void> removeNotification(String userId,  String notificationId) {
  
   return notificationRemoteDataSource.removeNotification(userId, notificationId);
  }
  
  @override
  Future<void> markAsRead(String userId, String notificationId ) {
  
    return notificationRemoteDataSource.markAsRead(userId , notificationId);
  }

}
