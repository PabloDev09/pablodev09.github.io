import 'package:afa/design/components/pending_user_component.dart';
import 'package:afa/design/components/active_user_component.dart';
import 'package:afa/logic/router/path/path_url_afa.dart';
import 'package:afa/logic/providers/user_request_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool _showActiveUsers = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Animación de fade-in
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true, // El fondo cubre toda la pantalla
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            // Título a la izquierda
            const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.052,),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Consumer<UserRequestProvider>(
                        builder: (context, requestProvider, child) {
                          final count = requestProvider.pendingUsers.length;
                          return count > 0
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$count',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12, // Badge más pequeño
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        },
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Peticiones de registro',
                        style: TextStyle(
                          color: _showActiveUsers ? Colors.grey : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Switch(
                        value: _showActiveUsers,
                        onChanged: (bool value) {
                          setState(() {
                            _showActiveUsers = value;
                          });
                        },
                        activeColor: Colors.white,
                        activeTrackColor: Colors.lightBlue,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Usuarios activos',
                        style: TextStyle(
                          color: _showActiveUsers ? Colors.white : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Botón de logout a la derecha
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      context.go(PathUrlAfa().pathWelcome);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.brightness == Brightness.dark
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFF063970),
              theme.brightness == Brightness.dark
                  ? const Color(0xFF121212)
                  : const Color(0xFF66B3FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _showActiveUsers
                      ? const ActiveUserComponent()
                      : const PendingUserComponentContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
