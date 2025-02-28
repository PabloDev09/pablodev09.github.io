import 'package:afa/logic/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:afa/logic/models/user.dart';

class UserRequestProvider extends ChangeNotifier 
{
  final UserService userService = UserService();
  List<User> pendingUsers = [
    const User(
      mail: 'juan@example.com',
      username: 'juan123',
      password: 'password1',
      name: 'Juan',
      surnames: 'Pérez',
      address: 'Calle Falsa 123, Jaén (23), 23001',
      phoneNumber: '600123456',
      rol: 'user',
      isActivate: false,
    ),
    const User(
      mail: 'ana@example.com',
      username: 'ana456',
      password: 'password2',
      name: 'Ana',
      surnames: 'García',
      address: 'Avenida Siempre Viva 742, Granada (18), 18001',
      phoneNumber: '600987654',
      rol: 'user',
      isActivate: false,
    ),
  ];

  Future<void> chargeUsers() async
  {

    List<User> users = await userService.getUsers();

    for(User user in users)
    {
      if(user.mail.trim().isNotEmpty && !user.isActivate)
      {
        pendingUsers.add(user);
      }
      
    }

    notifyListeners();
  }

  void acceptUser(User user) 
  {
    pendingUsers.remove(user);
    notifyListeners();
  }
}
