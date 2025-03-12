import 'package:afa/design/components/pending_user_component.dart';
import 'package:afa/design/components/active_user_component.dart';
import 'package:afa/logic/providers/user_active_provider.dart';
import 'package:afa/logic/providers/user_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:afa/design/components/side_bar_menu.dart'; 

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool _showActiveUsers = false;
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: _isMenuOpen ? const Color.fromARGB(30, 0, 0, 0) : Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                _isMenuOpen ? Icons.close : Icons.menu,
                color: _isMenuOpen ?  Colors.blue[700] : Colors.white,
              ),
              onPressed: _toggleMenu,
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Icon(
                        Icons.dashboard,
                        color: _isMenuOpen ? Colors.blue[700] : Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 8),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final textSize = constraints.maxWidth > 200 ? 24.0 : 20.0;
                          return Text(
                            'Dashboard',
                            style: TextStyle(
                              color: _isMenuOpen ? Colors.blue[700] : Colors.white,
                              fontSize: textSize,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        children: [
                          Consumer<UserRequestProvider>(
                            builder: (context, requestProvider, child) {
                              final count = requestProvider.pendingUsers.length;
                              return count > 0
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '$count',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : const SizedBox();
                            },
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.person_add_alt_rounded, color: Colors.white),
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
                          const Icon(Icons.person, color: Colors.white),
                          const SizedBox(width: 6),
                          Consumer<UserActiveProvider>(
                            builder: (context, activeProvider, child) {
                              final activeCount = activeProvider.activeUsers.length;
                              return activeCount > 0
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '$activeCount',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : const SizedBox();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
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
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
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
          if (_isMenuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          if (_isMenuOpen)
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SidebarMenu(
                selectedIndex: 1, 
                userName: "Juan Pérez",
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                '© 2025 AFA Andújar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
