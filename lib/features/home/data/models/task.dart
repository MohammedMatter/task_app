import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_app/features/home/data/models/category.dart';

class Task {
  String? id;
  String title;
  String description;
  DateTime date;
  Category category;
  String? statusName;
  Color? statusColor;
   bool notificationsEnabled;
     DateTime createdAt ;
  Task({
    required this.createdAt , 
    required this.notificationsEnabled , 
    required this.category,
    this.id,
    required this.date,
    required this.description,
    required this.title,
    required this.statusName,
    required this.statusColor,
  });

  factory Task.fromJson(Map json, String id ,) {
     final categoryData = json['category'] ;
    return Task(
      createdAt: (json['createdAt']as Timestamp).toDate(),
      notificationsEnabled:json['notificationsEnabled'] ,
        id: id,
        category: Category.fromJson(categoryData),
        date: (json['date'] as Timestamp).toDate(),
        description: json['description'],
        title: json['name'],
        statusName: json['status'],
        statusColor: json['status'] == 'UpComing'
            ? Colors.blue
            : json['status'] == 'InProgress'
                ? Colors.orange
                : Colors.green);
  }
}
