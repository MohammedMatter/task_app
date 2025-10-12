import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  String taskName ='';
  String taskCategory ='';

 void setTaskName(String taskName) {
    this.taskName = taskName ; 
    notifyListeners() ;
  }
 void setTaskCategory(String taskCategory) {
    this.taskCategory = taskCategory ; 
    notifyListeners() ;
  }
    void reset() {
    taskName = '';
    taskCategory = '';
    notifyListeners();
  }
}
