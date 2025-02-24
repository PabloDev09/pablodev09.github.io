import 'package:flutter/material.dart';
import 'package:afa/models/user_register.dart';

class UserRequestProvider extends ChangeNotifier {
  // Lista de usuarios pendientes (aquellos que aún no han sido activados)
  final List<UserRegister> _pendingUsers = [
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

  // Getter para acceder a la lista de usuarios pendientes.
  List<UserRegister> get pendingUsers => _pendingUsers;

  /// Método para aceptar un usuario:
  /// Se crea una nueva instancia del usuario con `isActivate` en true y se elimina de la lista de pendientes.
  void acceptUser(UserRegister user) {
    // Creamos una nueva instancia con isActivate = true
    final acceptedUser = UserRegister(
      mail: user.mail,
      username: user.username,
      password: user.password,
      name: user.name,
      surnames: user.surnames,
      address: user.address,
      phoneNumber: user.phoneNumber,
      rol: user.rol,
      isActivate: true,
    );
    // Por el momento, se elimina el usuario de la lista de pendientes.
    _pendingUsers.remove(user);
    // En un futuro, se podría actualizar la base de datos con la información de acceptedUser.
    notifyListeners();
  }

  /// Método para eliminar un usuario:
  /// Elimina el usuario de la lista de pendientes.
  void deleteUser(UserRegister user) {
    _pendingUsers.remove(user);
    // En el futuro, se implementará la eliminación en la base de datos.
    notifyListeners();
  }
}
