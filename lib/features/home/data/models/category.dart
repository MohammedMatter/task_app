import 'package:flutter/material.dart';

class Category {
  final String? name;
  final String? id;
  final Color color;
  final String? description;
  Category(
      {this.id,
      required this.name,
      required this.color,
      required this.description});

  factory Category.fromJson(Map json) {
    return Category(
        id: json['id'],
        name: json['name'],
        color: Color(json['color']),
        description: json['description']);
  }
}
