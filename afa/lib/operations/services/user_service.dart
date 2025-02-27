
import 'package:afa/operations/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService
{
  final FirebaseFirestore db = FirebaseFirestore.instance;

  UserService();

  Future<void> createUser(User userRegister) async
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

  Future<List<User>> getUsers() async 
  {
    List<User> usersRegister = [];
    CollectionReference collectionReferenceUsers = db.collection('usuarios');
    QuerySnapshot queryUsers = await collectionReferenceUsers.get();

    for (var documento in queryUsers.docs) 
    {
      final data = documento.data() as Map<String, dynamic>;
      final user = User.fromMap(data);
      usersRegister.add(user);
    }

    return usersRegister;
  }
}
