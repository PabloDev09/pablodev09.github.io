class User 
{
  final String mail;
  final String username;
  final String password;
  final String name;
  final String surnames;
  final String address;
  final String phoneNumber;
  final String rol;
  final bool isActivate;
  
  const User
  (
    {
    required this.mail, 
    required this.username, 
    required this.password, 
    required this.name, 
    required this.surnames, 
    required this.address, 
    required this.phoneNumber,
    this.rol = "",
    this.isActivate = false
    }
  );

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      mail: data['mail'] ?? '',
      username: data['username'] ?? '',
      password: data['password'] ?? '',
      name: data['name'] ?? '',
      surnames: data['surnames'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      rol: data['rol'] ?? '',
      isActivate: data['isActivate'] ?? false,
    );
  }
}