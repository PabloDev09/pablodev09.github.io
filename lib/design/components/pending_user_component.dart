import 'package:afa/logic/providers/user_request_provider.dart';
import 'package:afa/logic/models/user.dart';
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add_alt_rounded, color: Colors.white, size: 30),
                SizedBox(width: 6),
                Text(
                  'Peticiones de registro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (pendingUsers.isEmpty)
              _buildNoUsersDirectly(context)
            else
              _buildPendingUsersCards(context, pendingUsers),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildNoUsersDirectly(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.02;
    fontSize = fontSize.clamp(14, 18);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: fontSize * 4, color: Colors.grey),
            SizedBox(height: fontSize),
            Text(
              'No hay peticiones de registro',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: fontSize * 0.5),
            Text(
              'En cuanto existan usuarios pendientes se mostrarán aquí.',
              style: TextStyle(
                fontSize: fontSize * 0.9,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingUsersCards(BuildContext context, List<User> pendingUsers) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;
        double fontSize = constraints.maxWidth * 0.02;
        fontSize = fontSize.clamp(22, 24);
        double columnFactor = constraints.maxWidth / 340;
        columns = columnFactor.floor();
        double decimalPart = columnFactor - columns;
        fontSize = (fontSize + decimalPart * 6).clamp(22, 25);
        const double spacing = 16;
        final double totalSpacing = spacing * (columns - 1);
        final double itemWidth = (constraints.maxWidth - totalSpacing) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: pendingUsers.map((user) {
            return SizedBox(
              width: itemWidth,
              height: 350,
              child: _buildUserContainer(context, user, fontSize),
            );
          }).toList(),
        );
      },
    );
  }

  /// Contenedor interno. Va dentro de un SizedBox.
  Widget _buildUserContainer(BuildContext context, User user, double fontSize) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: _buildUserContent(context, user, fontSize),
        ),
      ),
    );
  }

  Widget _buildUserContent(BuildContext context, User user, double fontSize) {
    Map<IconData, Color> iconColors = {
      Icons.person: Colors.blue.shade300,
      Icons.email: Colors.green.shade300,
      Icons.phone: Colors.orange.shade300,
      Icons.location_on: Colors.red.shade300,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${user.name} ${user.surnames}',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.black54),
                      onPressed: () {
                        _showUserDetailsDialog(context, user);
                      },
                    ),
                  ],
                ),
                Text(
                  'Datos personales',
                  style: TextStyle(
                    fontSize: fontSize * 0.9,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Divider(),
                _buildUserInfoRow(Icons.person, 'Usuario:', user.username, fontSize, iconColors),
                _buildUserInfoRow(Icons.email, 'Email:', user.mail, fontSize, iconColors),
                _buildUserInfoRow(Icons.phone, 'Teléfono:', user.phoneNumber, fontSize, iconColors),
                _buildUserInfoRow(Icons.location_on, 'Dirección:', user.address, fontSize, iconColors),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildActionButtons(context, user),
        ),
      ],
    );
  }

  Widget _buildUserInfoRow(
    IconData icon,
    String label,
    String value,
    double fontSize,
    Map<IconData, Color> iconColors,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: fontSize * 1.2, color: iconColors[icon]),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: fontSize,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: fontSize * 0.95,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Los botones de acción ahora abrirán el mismo diálogo de detalles del usuario.
  Widget _buildActionButtons(BuildContext context, User user) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double iconSize = constraints.maxWidth * 0.15;
        iconSize = iconSize.clamp(20, 30);
        return Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF063970), Color(0xFF66B3FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(Icons.check, 'Aprobar', iconSize, () {
                _showUserDetailsDialog(context, user);
              }),
              _buildIconButton(Icons.edit, 'Editar', iconSize, () {
                _showUserDetailsDialog(context, user);
              }),
              _buildIconButton(Icons.close, 'Rechazar', iconSize, () {
                _showUserDetailsDialog(context, user);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, String tooltip, double size, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: size),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }

  /// Método único que abre el diálogo de detalles del usuario, igual que al pulsar los tres puntos.
  void _showUserDetailsDialog(BuildContext context, User user) {
    String name = user.name;
    String surnames = user.surnames;
    String username = user.username;
    String email = user.mail;
    String phone = user.phoneNumber;
    String address = user.address;
    bool isEditing = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (!isEditing) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Text('$name $surnames', style: const TextStyle(fontWeight: FontWeight.bold)),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Datos personales',
                        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Text('Usuario: $username'),
                      Text('Email: $email'),
                      Text('Teléfono: $phone'),
                      Text('Dirección: $address'),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    child: const Text('Editar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Aprobar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Eliminar'),
                  ),
                ],
              );
            } else {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Text('Editar usuario', style: TextStyle(fontWeight: FontWeight.bold)),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(labelText: 'Nombre'),
                        controller: TextEditingController(text: name),
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Apellidos'),
                        controller: TextEditingController(text: surnames),
                        onChanged: (value) {
                          surnames = value;
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Usuario'),
                        controller: TextEditingController(text: username),
                        onChanged: (value) {
                          username = value;
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        controller: TextEditingController(text: email),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Teléfono'),
                        controller: TextEditingController(text: phone),
                        onChanged: (value) {
                          phone = value;
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Dirección'),
                        controller: TextEditingController(text: address),
                        onChanged: (value) {
                          address = value;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Guardar cambios'),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}
