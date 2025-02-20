import 'package:afa/models/user_register.dart';
import 'package:afa/helpers/get_provinces_cities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  late UserRegister userRegister;
  final GetProvincesCities _getProvincesCities = GetProvincesCities();
  
  final List<String> provincesNames = [
    'Almería',
    'Cádiz',
    'Córdoba',
    'Granada',
    'Huelva',
    'Jaén',
    'Málaga',
    'Sevilla'
  ];
  
  List<Map<String, String>> provinces = [
    {"provincia": "Jaén", "codigoProvincia": "23"},
    {"provincia": "Granada", "codigoProvincia": "18"},
    {"provincia": "Almería", "codigoProvincia": "04"},
    {"provincia": "Córdoba", "codigoProvincia": "14"},
    {"provincia": "Sevilla", "codigoProvincia": "41"},
    {"provincia": "Málaga", "codigoProvincia": "29"},
    {"provincia": "Huelva", "codigoProvincia": "21"},
    {"provincia": "Cádiz", "codigoProvincia": "11"},
  ];
  
  List<String> cities = [];
  
  List<String> domainMails = [
    "@gmail.com",
    "@yahoo.com",
    "@hotmail.com",
    "@outlook.com",
    "@live.com",
    "@icloud.com",
    "@mail.com",
    "@protonmail.com",
    "@zoho.com",
    "@yandex.com",
    "@gmx.com",
    "@fastmail.com",
  ];
  
  String? selectedProvince;
  String? selectedCity;
  
  // Actualiza la provincia seleccionada y carga las ciudades asociadas.
  void setSelectedProvince(String province) async {
    selectedProvince = province;
    selectedCity = null; // Resetear la ciudad
    notifyListeners();
  
    String? provinceCode = provinces.firstWhere(
      (element) => element["provincia"] == province,
      orElse: () => {}
    )["codigoProvincia"];
  
    if (provinceCode != null && provinceCode.isNotEmpty) {
      await getCitiesForProvince(provinceCode);
    }
  }
  
  // Actualiza la ciudad seleccionada
  void setSelectedCity(String city) {
    selectedCity = city;
    notifyListeners();
  }
  
  // Obtiene la lista de ciudades para la provincia seleccionada.
  Future<void> getCitiesForProvince(String provinceCode) async {
    try {
      cities = await _getProvincesCities.fetchCities(provinceCode);
    } catch (e) {
      cities = [];
    }
    notifyListeners();
  }
  
  bool isCorrectMail(String value) {
    for (String domainMail in domainMails) {
      if (value.endsWith(domainMail)) {
        return true;
      }
    }
    return false;
  }
  
  String joinAddress(String street, String city, String province, String postalCode)
  {
    return "${street.trim()}, ${city.trim()}(${province.trim()}), ${postalCode.trim()}";
  }

  /// Método para crear el usuario y almacenarlo en la colección "usuarios" de Firestore.
  Future<void> registerUser({
    required String mail,
    required String username,
    required String password,
    required String name,
    required String surnames,
    required String address,
    required String phoneNumber,
  }) async {
    // Crea la instancia de UserRegister
    userRegister = UserRegister(
      mail: mail,
      username: username,
      password: password,
      name: name,
      surnames: surnames,
      address: address,
      phoneNumber: phoneNumber,
    );
  
    // Almacena en Firestore en la colección "usuarios"
    await FirebaseFirestore.instance.collection('usuarios').add({
      'mail': userRegister.mail,
      'username': userRegister.username,
      'password': userRegister.password,
      'name': userRegister.name,
      'surnames': userRegister.surnames,
      'address': userRegister.address,
      'phoneNumber': userRegister.phoneNumber,
      'rol': userRegister.rol,
      'isActivate': userRegister.isActivate,
    });
  }
}
