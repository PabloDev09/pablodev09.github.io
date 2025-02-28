import 'package:afa/design/components/pending_user_component.dart';
import 'package:afa/design/components/active_user_component.dart';
import 'package:afa/logic/router/path/path_url_afa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Estado que controla si se muestran usuarios activos o pendientes
  bool _showActiveUsers = false;

  @override
  Widget build(BuildContext context) {
    // Azul oscuro principal (igual que el AppBar)
    const Color mainBlue = Color(0xFF063970);

    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        backgroundColor: mainBlue,
        title: const Text("Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                context.go(PathUrlAfa().pathWelcome);
              }
            },
          ),
        ],
      ),
      // Usamos LayoutBuilder para obtener el alto disponible y
      // permitir que la columna se expanda y sea desplazable si es necesario.
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              // Asegura que la columna ocupe al menos el alto total del viewport
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Encabezado con el switch para alternar entre componentes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Etiqueta para "Usuarios pendientes"
                      Text(
                        'Usuarios pendientes',
                        style: TextStyle(
                          // Si está mostrando usuarios activos, "pendientes" se ve más tenue
                          color: _showActiveUsers ? Colors.grey : mainBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Switch para alternar entre usuarios pendientes y activos
                      Switch(
                        value: _showActiveUsers,
                        onChanged: (bool value) {
                          setState(() {
                            _showActiveUsers = value;
                          });
                        },
                        // El pulgar (thumb) en blanco y la pista (track) en azul oscuro
                        activeColor: Colors.white,        // Color del pulgar (thumb)
                        activeTrackColor: mainBlue,       // Pista cuando está activo
                        inactiveThumbColor: Colors.white, // Pulgar cuando está inactivo
                        inactiveTrackColor: Colors.grey,  // Pista cuando está inactivo
                      ),
                      const SizedBox(width: 8),
                      // Etiqueta para "Usuarios activos"
                      Text(
                        'Usuarios activos',
                        style: TextStyle(
                          // Si está mostrando usuarios activos, "activos" en azul; sino gris
                          color: _showActiveUsers ? mainBlue : Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Contenido principal: usuarios pendientes o activos
                  // (No usamos Expanded, sino que dejamos que la columna crezca y sea desplazable)
                  if (_showActiveUsers)
                    const ActiveUserComponent()
                  else
                    const PendingUserComponentContent(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
