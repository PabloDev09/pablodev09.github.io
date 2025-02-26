import 'package:afa/path/path_url_afa.dart';
import 'package:afa/providers/user_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:afa/models/user_register.dart';

class PendingUsersScreen extends StatelessWidget {
  const PendingUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth =
        screenWidth * 0.9 > 600 ? 600 : screenWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF063970),
        elevation: 2,
        shadowColor: Colors.black26,
        leadingWidth: 150,
        leading: TextButton.icon(
          onPressed: () => context.go(PathUrlAfa().pathWelcome),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          label: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Volver al inicio',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
      body: Consumer<UserRequestProvider>(
        builder: (context, userRequestProvider, _) {
          final pendingUsers = userRequestProvider.pendingUsers;
          if (pendingUsers.isEmpty) {
            return const Center(
              child: Text(
                'No hay peticiones de registro',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: containerWidth,
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título encima de los contenedores de usuarios
                    const Center(
                      child: Text(
                        'Usuarios pendientes de aprobar',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF063970),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: pendingUsers
                            .map((user) => _buildUserCard(context, user))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, UserRegister user) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Para anchos mayores a 400 se muestra en dos columnas
            if (constraints.maxWidth > 400) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información del usuario en dos columnas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Columna izquierda: Nombre completo y username
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.name} ${user.surnames}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Username: ${user.username}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      // Columna derecha: Correo y teléfono
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            user.mail,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tel: ${user.phoneNumber}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Botones de acción: Aceptar, Editar y Eliminar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Provider.of<UserRequestProvider>(context, listen: false)
                              .acceptUser(user);
                        },
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const SizedBox.shrink(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () => _showEditUserDialog(context, user),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const SizedBox.shrink(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Acción para eliminar el usuario pendiente
                        },
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const SizedBox.shrink(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              // Para anchos pequeños se muestra la información en columna
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name} ${user.surnames}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Username: ${user.username}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.mail,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tel: ${user.phoneNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Provider.of<UserRequestProvider>(context, listen: false)
                              .acceptUser(user);
                        },
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const SizedBox.shrink(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () => _showEditUserDialog(context, user),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const SizedBox.shrink(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Acción para eliminar el usuario pendiente
                        },
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const SizedBox.shrink(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // Diálogo de edición con contenedor más grande y colores coherentes con la página
  void _showEditUserDialog(BuildContext context, UserRegister user) {
    final nameController = TextEditingController(text: user.name);
    final surnamesController = TextEditingController(text: user.surnames);
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.mail);
    final phoneController = TextEditingController(text: user.phoneNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.lightBlue[50],
          title: const Text("Editar usuario"),
          content: SizedBox(
            width: 400, // Contenedor más grande para la edición
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nombre",
                      filled: true,
                      fillColor: Colors.lightBlue[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: surnamesController,
                    decoration: InputDecoration(
                      labelText: "Apellidos",
                      filled: true,
                      fillColor: Colors.lightBlue[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      filled: true,
                      fillColor: Colors.lightBlue[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Correo electrónico",
                      filled: true,
                      fillColor: Colors.lightBlue[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Teléfono",
                      filled: true,
                      fillColor: Colors.lightBlue[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                // Implementar lógica de guardado, por ejemplo mediante el provider.
                print("Usuario actualizado: ${nameController.text}, ${surnamesController.text}, ${usernameController.text}, ${emailController.text}, ${phoneController.text}");
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
              ),
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}
