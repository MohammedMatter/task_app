import 'package:flutter/material.dart';

class ThemeViewModel extends ChangeNotifier{
bool  nightThemeEnabled = false ; 

switchTheme(bool val){
  nightThemeEnabled = val ; 
  notifyListeners() ; 

}
 void reset() {
    nightThemeEnabled = false;
    notifyListeners();
  }
  

}