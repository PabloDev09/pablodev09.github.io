import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afa/logic/providers/user_active_provider.dart';

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
            const SizedBox(height: 30),
            // Si NO hay usuarios, se muestra directamente el mensaje en el centro
            if (activeUsers.isEmpty)
              _buildNoUsersDirectly(context)
            else
              // Si HAY usuarios, se muestra la tabla dentro de un contenedor con sombra.
              _buildActiveUsersContainer(context, activeUsers),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }

  /// Muestra un mensaje centrado horizontal y verticalmente SIN contenedor adicional
  Widget _buildNoUsersDirectly(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.7, // 70% de la pantalla
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono principal (personas) con la X roja superpuesta
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
                fontFamily: 'Roboto',  // Fuente moderna
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

  /// Contenedor con sombra y bordes redondeados que aloja la tabla
  Widget _buildActiveUsersContainer(BuildContext context, List activeUsers) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: _buildActiveUsersTable(context, activeUsers),
      ),
    );
  }

  /// Tabla con encabezado y filas
  Widget _buildActiveUsersTable(BuildContext context, List activeUsers) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16), // Borde redondeado de la tabla
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowHeight: 70, // Encabezados más altos para mejorar la legibilidad
                  columns: const [
                    DataColumn(label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                    DataColumn(label: Text('Username', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                    DataColumn(label: Text('Correo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                    DataColumn(label: Text('Teléfono', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                    DataColumn(label: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  ],
                  rows: [
                    for (int i = 0; i < activeUsers.length; i++)
                      DataRow(
                        color: i % 2 == 0
                            ? WidgetStateProperty.all(Colors.lightGreen[50]) // Fondo verde suave
                            : WidgetStateProperty.all(Colors.blue[50]), // Fondo azul suave
                        cells: [
                          DataCell(Text('${activeUsers[i].name} ${activeUsers[i].surnames}', style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'))),
                          DataCell(Text(activeUsers[i].username, style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'))),
                          DataCell(Text(activeUsers[i].mail, style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'))),
                          DataCell(Text(activeUsers[i].phoneNumber, style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'))),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Botón editar
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editUser(context, activeUsers[i]),
                                  tooltip: 'Editar usuario',
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 8),
                                // Botón eliminar
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteUser(context, activeUsers[i]),
                                  tooltip: 'Eliminar usuario',
                                  color: Colors.redAccent,
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

  /// Ejemplo de acción para editar
  void _editUser(BuildContext context, dynamic user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar usuario'),
        content: Text('Editar a ${user.username}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Lógica para guardar cambios
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  /// Ejemplo de acción para eliminar
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
              // Lógica para eliminar el usuario del provider
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
