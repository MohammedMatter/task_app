import 'package:flutter/material.dart';
import 'package:task_app/features/home/domain/Entities/search_type.dart';

class FilterViewModel extends ChangeNotifier {
  SearchType searchType = SearchType.task;

  setSearchType(SearchType searchType) {
    this.searchType = searchType;
    notifyListeners();
  }
    void reset() {
    searchType = SearchType.task;
    notifyListeners();
  }
}
