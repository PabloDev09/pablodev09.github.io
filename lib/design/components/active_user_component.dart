import 'package:afa/logic/models/user.dart';
import 'package:afa/logic/providers/user_active_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveUserComponent extends StatelessWidget {
  const ActiveUserComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserActiveProvider>(
      builder: (context, activeUserProvider, _) {
        final activeUsers = activeUserProvider.activeUsers;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título fijo para usuarios activos
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, color: Colors.white, size: 30),
                SizedBox(width: 6),
                Text(
                  'Usuarios Activos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Si no hay usuarios, se muestra un mensaje centrado
            if (activeUsers.isEmpty)
              _buildNoUsersDirectly(context)
            else
              _buildActiveUsersCards(context, activeUsers),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  /// Muestra un mensaje centrado en caso de que no haya usuarios activos.
  Widget _buildNoUsersDirectly(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double fontSize = MediaQuery.of(context).size.width * 0.02;
    fontSize = fontSize.clamp(14, 18);

    return SizedBox(
      height: screenHeight * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono principal para usuarios activos con X roja superpuesta
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.people_alt_rounded,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.cancel_rounded,
                      size: 100,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No hay usuarios activos',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'En cuanto existan usuarios activos se mostrarán aquí.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Construye las tarjetas de usuarios activos en una cuadrícula.
  Widget _buildActiveUsersCards(BuildContext context, List<User> activeUsers) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;
        double fontSize = constraints.maxWidth * 0.02;
        fontSize = fontSize.clamp(22, 24);

        double columnFactor = constraints.maxWidth / 375;
        columns = columnFactor.floor();
        double decimalPart = columnFactor - columns;
        fontSize = (fontSize + decimalPart * 6).clamp(22, 25);

        const double spacing = 16;
        final double totalSpacing = spacing * (columns - 1);
        final double itemWidth = (constraints.maxWidth - totalSpacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: activeUsers.map((user) {
            return SizedBox(
              width: itemWidth,
              height: 400, 
              child: _buildUserContainer(context, user, fontSize),
            );
          }).toList(),
        );
      },
    );
  }

  /// Contenedor interno para cada usuario activo, con gradiente y sombra distintiva.
  Widget _buildUserContainer(BuildContext context, User user, double fontSize) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: const BoxDecoration
        (
          // Gradiente en tonos verdes para identificar usuarios activos
          color: Colors.white
          ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: _buildUserContent(context, user, fontSize),
        ),
      ),
    );
  }

  /// Muestra la información del usuario activo, incluyendo rol.
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
        // Información principal con scroll si es necesario
        Flexible(
          fit: FlexFit.tight,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del usuario y botón para más detalles
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
                _buildUserInfoRow(Icons.security, 'Rol:', user.rol, fontSize, iconColors)
              ],
            ),
          ),
        ),
        // Botones de acción fijos en la parte inferior del contenedor
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildActionButtons(context, user),
        ),
      ],
    );
  }

  /// Fila de información para cada dato (usuario, email, etc.)
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
              color: const Color.fromARGB(255, 0, 0, 0),
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

  /// Botones de acción: Dar de baja y Eliminar
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
              colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón para dar de baja
              _buildIconButton(Icons.remove_circle_outline, 'Dar de baja', iconSize, () {
                _deactivateUser(context, user);
              }),
              // Botón para eliminar
              _buildIconButton(Icons.delete, 'Eliminar', iconSize, () {
                _deleteUser(context, user);
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

  void _deactivateUser(BuildContext context, dynamic user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Dar de baja usuario'),
        content: Text('¿Estás seguro de dar de baja a ${user.username}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Lógica para desactivar al usuario
              Navigator.pop(context);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(BuildContext context, dynamic user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: Text('¿Deseas eliminar a ${user.username}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Lógica para eliminar al usuario
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

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
