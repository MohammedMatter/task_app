import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_app/features/home/data/models/category.dart';

class CategoryRemoteDataSource {
  Future addCategory(String userId, Category category, int colorVal) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final docRef = users.doc(userId).collection('categories').doc();
    String id = docRef.id;
    await docRef.set({
      'name': category.name,
      'id': id,
      'color': colorVal,
      'description': category.description
    });

    return Category(
      id: id,
      name: category.name,
      color: Color(colorVal),
      description: category.description,
    );
  }

  Future fetchCategories(String userId) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final snapshots = await users.doc(userId).collection('categories').get();

    return snapshots.docs.map(
      (doc) {
        return Category.fromJson(doc.data());
      },
    ).toList();
  }

  Future deleteCategory(String userId, String idCategory) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    await users.doc(userId).collection('categories').doc(idCategory).delete();
  }

  Future<Category> updateCategory(String userId, String idCategory, String newName,
      String newDescription) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('users');
        final docRef =     await users.doc(userId).collection('categories').doc(idCategory).get() ; 
     final    data = docRef.data()as Map<String , dynamic> ; 
    await users.doc(userId).collection('categories').doc(idCategory).update({
      'name': newName,
      'description':newDescription
    });
  return Category(color:_parseColor(data['color'])  , description: newDescription , name: newName , id:idCategory) ; 
  }
  Color _parseColor(int colorData) {
 
    return Color(colorData); 
}
}
