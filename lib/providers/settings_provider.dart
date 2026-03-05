import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _locationNotificationsEnabled = false;

  bool get locationNotificationsEnabled => _locationNotificationsEnabled;

  void toggleLocationNotifications(bool value) {
    _locationNotificationsEnabled = value;
    notifyListeners();
  }
}
