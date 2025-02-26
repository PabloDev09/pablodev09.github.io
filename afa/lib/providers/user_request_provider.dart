import 'package:afa/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:afa/models/user_register.dart';

class UserRequestProvider extends ChangeNotifier 
{
  final UserService userService = UserService();
  List<UserRegister> pendingUsers = [
    const UserRegister(
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
    const UserRegister(
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

    List<UserRegister> users = await userService.getUsers();

    for(UserRegister user in users)
    {
      if(user.mail.trim().isNotEmpty)
      {
        pendingUsers.add(user);
      }
      
    }

    notifyListeners();
  }

  void acceptUser(UserRegister user) 
  {
    pendingUsers.remove(user);
    notifyListeners();
  }
}
