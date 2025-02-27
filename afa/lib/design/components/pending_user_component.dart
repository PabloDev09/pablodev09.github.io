import 'package:afa/operations/providers/user_request_provider.dart';
import 'package:afa/operations/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingUserComponentContent extends StatelessWidget {
  const PendingUserComponentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserRequestProvider>(
      builder: (context, userRequestProvider, _) {
        final pendingUsers = userRequestProvider.pendingUsers;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Si no hay usuarios pendientes, muestra el mensaje grande centrado
            if (pendingUsers.isEmpty)
              _buildNoUsersDirectly(context)
            else
              // Si hay usuarios pendientes, muestra la tabla en un contenedor
              _buildPendingUsersContainer(context, pendingUsers),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  /// Muestra un mensaje grande centrado (horizontal y vertical) cuando no hay usuarios pendientes
  Widget _buildNoUsersDirectly(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.7, // Ocupa el 70% de la pantalla (ajusta según necesites)
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono de personas con "X" roja superpuesta
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add_comment_rounded,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.close,
                      size: 100,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'No hay peticiones de registro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'En cuanto existan usuarios pendientes se mostrarán aquí.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Contenedor con sombra y bordes redondeados para la tabla de usuarios pendientes
  Widget _buildPendingUsersContainer(BuildContext context, List<User> pendingUsers) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: _buildPendingUsersTable(context, pendingUsers),
      ),
    );
  }

  /// Tabla de usuarios pendientes que se redimensiona en pantallas pequeñas (sin scroll horizontal)
  Widget _buildPendingUsersTable(BuildContext context, List<User> pendingUsers) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical, // Scroll vertical si excede la altura
            child: FittedBox(
              // Ajusta la tabla para que quepa en el ancho disponible
              fit: BoxFit.scaleDown,
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowHeight: 0, // Ocultamos cabecera automática
                  columns: const [
                    DataColumn(label: SizedBox()),
                    DataColumn(label: SizedBox()),
                    DataColumn(label: SizedBox()),
                    DataColumn(label: SizedBox()),
                    DataColumn(label: SizedBox()),
                  ],
                  rows: [
                    // FILA 2: Encabezados de columnas
                    DataRow(
                      color: WidgetStateProperty.all(
                        const Color(0xFF074D96),
                      ),
                      cells: const [
                        DataCell(
                          Text(
                            'Nombre',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            'Username',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            'Correo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            'Teléfono',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            'Acciones',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // FILAS DE DATOS (alternando colores y con hover)
                    for (int i = 0; i < pendingUsers.length; i++)
                      DataRow(
                        color: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            final hovered = states.contains(WidgetState.hovered);
                            // Alternamos colores par/impar y cambiamos en hover
                            if (i % 2 == 0) {
                              // Fila par
                              return hovered
                                  ? const Color.fromARGB(255, 164, 215, 255) // hover
                                  : const Color(0xFF95CFFF); // base
                            } else {
                              // Fila impar
                              return hovered
                                  ? const Color.fromARGB(255, 187, 224, 255) // hover
                                  : const Color(0xFFB3DAFF); // base
                            }
                          },
                        ),
                        cells: [
                          DataCell(
                            Text('${pendingUsers[i].name} ${pendingUsers[i].surnames}'),
                          ),
                          DataCell(
                            Text(pendingUsers[i].username),
                          ),
                          DataCell(
                            Text(pendingUsers[i].mail),
                          ),
                          DataCell(
                            Text(pendingUsers[i].phoneNumber),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Botón de Aceptar (check verde con hover)
                                IconButton(
                                  icon: const Icon(Icons.check),
                                  style: ButtonStyle(
                                    iconSize: WidgetStateProperty.all(24),
                                    foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                                      (states) {
                                        if (states.contains(WidgetState.hovered)) {
                                          return Colors.greenAccent;
                                        }
                                        return Colors.green;
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    Provider.of<UserRequestProvider>(context, listen: false)
                                        .acceptUser(pendingUsers[i]);
                                  },
                                ),
                                // Botón de Editar (lápiz naranja con hover)
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  style: ButtonStyle(
                                    iconSize: WidgetStateProperty.all(24),
                                    foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                                      (states) {
                                        if (states.contains(WidgetState.hovered)) {
                                          return Colors.deepOrange;
                                        }
                                        return Colors.orange;
                                      },
                                    ),
                                  ),
                                  onPressed: () =>
                                      _showEditUserDialog(context, pendingUsers[i]),
                                ),
                                // Botón de Eliminar (papelera roja con hover)
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  style: ButtonStyle(
                                    iconSize: WidgetStateProperty.all(24),
                                    foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                                      (states) {
                                        if (states.contains(WidgetState.hovered)) {
                                          return Colors.redAccent;
                                        }
                                        return Colors.red;
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    // Acción para eliminar el usuario pendiente
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
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

  /// Diálogo de edición
  void _showEditUserDialog(BuildContext context, User user) {
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
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(nameController, "Nombre"),
                  const SizedBox(height: 10),
                  _buildTextField(surnamesController, "Apellidos"),
                  const SizedBox(height: 10),
                  _buildTextField(usernameController, "Username"),
                  const SizedBox(height: 10),
                  _buildTextField(emailController, "Correo electrónico"),
                  const SizedBox(height: 10),
                  _buildTextField(phoneController, "Teléfono"),
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
                // Implementar la lógica de guardado (actualizar el provider, etc.)
                print(
                  "Usuario actualizado: "
                  "${nameController.text}, "
                  "${surnamesController.text}, "
                  "${usernameController.text}, "
                  "${emailController.text}, "
                  "${phoneController.text}",
                );
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

  /// Crea un TextField con estilo uniforme
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.lightBlue[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
