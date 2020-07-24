import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  String text = '練習';

  void changeText(){
    text = '変更2';
    notifyListeners();
  }
}