import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/features/home/data/models/category.dart';
import 'package:task_app/features/home/data/models/task.dart';

class TaskRemoteDataSource {
  Future<Task> addTasks(String uid, Task task) async {
    CollectionReference users =
        await FirebaseFirestore.instance.collection('users');
    DocumentReference docRef = await users.doc(uid).collection('tasks').doc();
    String id = docRef.id;
    await docRef.set({
      'name': task.title,
      'date': task.date,
      'category': {
        'name': task.category.name,
        'id': task.category.id,
        'color': task.category.color.toARGB32(),
        'description': task.category.description
      },
      'description': task.description,
      'status': task.statusName,
      'id': id,
      'notificationsEnabled': task.notificationsEnabled,
      'createdAt': DateTime.now()
    });

    return Task(
      createdAt: task.createdAt,
      notificationsEnabled: task.notificationsEnabled,
      id: id,
      category: task.category,
      date: task.date,
      description: task.description,
      title: task.title,
      statusName: task.statusName,
      statusColor: task.statusColor,
    );
  }

  Future removeTasks(String userId, String taskId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  Future<List> fetchTasks(String userId) async {
    log('fetch tasks  : ${userId}');
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .get();
    return snapshot.docs.map(
      (doc) {
        return Task.fromJson(doc.data(), doc.id);
      },
    ).toList();
  }

  Future<List> updateCategoryTasks(
      String userId, Category category, List<Task> tasks) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    for (var element in tasks) {
      log('***${element.id!}');
      await users.doc(userId).collection('tasks').doc(element.id).update(
        {
          'category': {
            'color': category.color.toARGB32(),
            'id': category.id,
            'name': category.name,
            'description': category.description
          }
        },
      );
    }

    return tasks;
  }

  Future<void> updateTask(String userId, String taskId, Task task) async {
    CollectionReference users =
        await FirebaseFirestore.instance.collection('users');
    await users.doc(userId).collection('tasks').doc(taskId).update({
      'name': task.title,
      'description': task.description,
      'date': task.date,
      'notificationsEnabled': task.notificationsEnabled,
      'category': {
        'name': task.category.name,
        'description': task.category.description,
        'id': '0',
        'color': task.category.color.toARGB32()
      }
    });
  }
}
