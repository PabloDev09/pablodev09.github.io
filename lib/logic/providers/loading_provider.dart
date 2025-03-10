import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  bool isScreenChange = true;


  void screenChange() {
    isScreenChange = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
        _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    isScreenChange = false;
    notifyListeners();
  }
}
