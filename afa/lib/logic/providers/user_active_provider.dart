import 'package:afa/logic/models/user.dart';
import 'package:afa/logic/services/user_service.dart';
import 'package:flutter/material.dart';

class UserActiveProvider extends ChangeNotifier {
  final UserService userService = UserService();
  
  List<User> activeUsers = [
    const User(
      mail: 'maria@example.com',
      username: 'maria',
      password: 'password3',
      name: 'Maria',
      surnames: 'López',
      address: 'Calle Real 456, Sevilla (41), 41001',
      phoneNumber: '600654321',
      rol: 'user',
      isActivate: true,
    ),
    const User(
      mail: 'carlos@example.com',
      username: 'carlos',
      password: 'password4',
      name: 'Carlos',
      surnames: 'Martínez',
      address: 'Avenida Principal 789, Madrid (01), 28001',
      phoneNumber: '600987321',
      rol: 'user',
      isActivate: true,
    ),
  ];

  Future<void> chargeUsers() async {
    List<User> users = await userService.getUsers();
    for (User user in users) {
      if (user.mail.trim().isNotEmpty && user.isActivate) {
        activeUsers.add(user);
      }
    }
    notifyListeners();
  }

  void removeUser(User user) {
    activeUsers.remove(user);
    notifyListeners();
  }
}
