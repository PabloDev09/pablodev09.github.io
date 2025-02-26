
import 'package:afa/models/user_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService
{
  final FirebaseFirestore db = FirebaseFirestore.instance;

  UserService();

  Future<void> createUser(UserRegister userRegister) async
  {
    CollectionReference collectionReferenceUsers = db.collection('usuarios');

    await collectionReferenceUsers.add
    (
      {
        'mail': userRegister.mail,
        'username': userRegister.username,
        'password': userRegister.password,
        'name': userRegister.name,
        'surnames': userRegister.surnames,
        'address' : userRegister.address,
        'phoneNumber': userRegister.phoneNumber,
        'rol': userRegister.rol,
        'isActivate': userRegister.isActivate
      }
    );
  }

  Future<List<UserRegister>> getUsers() async 
  {
    List<UserRegister> usersRegister = [];
    CollectionReference collectionReferenceUsers = db.collection('usuarios');
    QuerySnapshot queryUsers = await collectionReferenceUsers.get();

    for (var documento in queryUsers.docs) 
    {
      final data = documento.data() as Map<String, dynamic>;
      final user = UserRegister.fromMap(data);
      usersRegister.add(user);
    }

    return usersRegister;
  }
}
