import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationApp {
  String? body;
  String? title;
  DateTime? timestamp;
  String? idNotification;
  bool isRead;
  String type;
  DateTime duaAt;

  NotificationApp({
    required this.duaAt,
    required this.type,
    required this.isRead,
    required this.body,
    required this.title,
    required this.timestamp,
    this.idNotification,

  });

  factory NotificationApp.fromJson(Map json, String id) {
    return NotificationApp(
      duaAt: (json['dueAt'] as Timestamp).toDate(),
      type: json['type'],
      isRead: json['isRead'],
      idNotification: id,
      body: json['body'],
      title: json['title'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }
}
