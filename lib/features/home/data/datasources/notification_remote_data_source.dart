import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/features/home/data/models/notification.dart';

class NotificationRemoteDataSource {
  Future<NotificationApp> addNotification(
      String userId, NotificationApp notification) async {
    final users = await FirebaseFirestore.instance.collection('users');
    final collectionReferenceNotification =
        users.doc(userId).collection('notifications').doc();
    String notificationId = collectionReferenceNotification.id;
    collectionReferenceNotification.set({
      "title": notification.title,
      "body": notification.body,
      "timestamp": notification.timestamp,
      "idNotification": notificationId,
      "isRead": false,
      'type': notification.type,
      'dueAt': notification.duaAt
    });
    return NotificationApp(
        duaAt: notification.duaAt,
        type: notification.type,
        isRead: notification.isRead,
        idNotification: notificationId,

        body: notification.body,
        title: notification.title,
        timestamp: notification.timestamp);
  }

  Future<void> removeNotification(String userId, String notificationId) async {
    final users = await FirebaseFirestore.instance.collection('users');

    users.doc(userId).collection('notifications').doc(notificationId).delete();
  }

  Future<List<NotificationApp>> fetchNotification(String userId) async {
    final users = await FirebaseFirestore.instance.collection('users');
    final snapshot = await users.doc(userId).collection('notifications').get();
    return snapshot.docs
        .map(
          (doc) => NotificationApp.fromJson(doc.data() ,doc.reference.id ),
        )
        .toList();
  }

  Future<void> markAsRead(userId, notificationId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }
}
