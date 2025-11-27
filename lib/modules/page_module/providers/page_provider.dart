import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier{
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void setCurrentPage(int page) {
    if (_currentPage != page) {
      _currentPage = page;
      notifyListeners();
    }
  }
}