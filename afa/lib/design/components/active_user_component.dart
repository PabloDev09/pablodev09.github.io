import 'package:afa/operations/providers/user_active_provider.dart';
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
            const SizedBox(height: 20),
            // Si NO hay usuarios, se muestra directamente el mensaje en el centro
            if (activeUsers.isEmpty)
              _buildNoUsersDirectly(context)
            else
              // Si HAY usuarios, se muestra la tabla dentro de un contenedor con sombra.
              _buildActiveUsersContainer(context, activeUsers),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  /// Muestra un mensaje centrado horizontal y verticalmente SIN contenedor adicional
  Widget _buildNoUsersDirectly(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.7, // 70% de la pantalla (ajusta según necesites)
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono principal (personas) con la X roja superpuesta
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.how_to_reg_rounded,
                      size: 100,
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
              'No hay usuarios activos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'En cuanto existan usuarios activos se mostrarán aquí.',
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

  /// Contenedor con sombra y bordes redondeados que aloja la tabla
  Widget _buildActiveUsersContainer(BuildContext context, List activeUsers) {
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
        child: _buildActiveUsersTable(context, activeUsers),
      ),
    );
  }

  /// Tabla con encabezado y filas (sin scroll horizontal: se escala en pantallas pequeñas)
  Widget _buildActiveUsersTable(BuildContext context, List activeUsers) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12), // Borde redondeado de la tabla
      child: LayoutBuilder(
        builder: (context, constraints) {
          // SINGLE SCROLL VERTICAL
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FittedBox(
              // Ajusta la tabla para que quepa en el ancho disponible (scale down)
              fit: BoxFit.scaleDown,
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                // Mínimo: todo el ancho de la zona disponible
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowHeight: 0, // Ocultamos la cabecera automática
                  columns: const [
                    DataColumn(label: SizedBox()),
                    DataColumn(label: SizedBox()),
                    DataColumn(label: SizedBox()),
                    DataColumn(label: SizedBox()),
                    DataColumn(label: SizedBox()),
                  ],
                  rows: [
                    // FILA DE ENCABEZADO
                    DataRow(
                      color: WidgetStateProperty.all(const Color(0xFF074D96)),
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
                    // FILAS DE DATOS
                    for (int i = 0; i < activeUsers.length; i++)
                      DataRow(
                        // Color de fila con hover
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
                            Text('${activeUsers[i].name} ${activeUsers[i].surnames}'),
                          ),
                          DataCell(
                            Text(activeUsers[i].username),
                          ),
                          DataCell(
                            Text(activeUsers[i].mail),
                          ),
                          DataCell(
                            Text(activeUsers[i].phoneNumber),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Botón editar (lápiz naranja con hover)
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
                                  onPressed: () => _editUser(context, activeUsers[i]),
                                ),
                                // Botón eliminar (papelera roja con hover)
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
                                  onPressed: () => _deleteUser(context, activeUsers[i]),
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
