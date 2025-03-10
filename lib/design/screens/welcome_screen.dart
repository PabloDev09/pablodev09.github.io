import 'dart:async';
import 'dart:ui';
import 'package:afa/logic/providers/loading_provider.dart';
import 'package:afa/logic/router/path/path_url_afa.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _messages = [
    {"icon": Icons.elderly, "text": "Tu movilidad, nuestra prioridad"},
    {"icon": Icons.favorite, "text": "Siempre cuidando de ti"},
    {"icon": Icons.accessible, "text": "Te acompañamos con seguridad"},
    {"icon": Icons.health_and_safety, "text": "Tu bienestar es lo primero"},
    {"icon": Icons.volunteer_activism, "text": "Mano a mano, llegamos lejos"},
  ];

  int _currentMessageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: true);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(child: _buildDynamicMessage()),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height * 0.65,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
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
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      child: const Text(
                        'Bienvenido a AFA Andújar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          // Ejemplo de fontFamily:
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.zero,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Gestiona de forma segura y sencilla la recogida de personas con discapacidad y mayores. '
                                'Realiza el seguimiento en tiempo real mediante mapas interactivos.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              const SizedBox(height: 30),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return constraints.maxWidth < 400
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            _buildButton(
                                              context,
                                              'Registrarse',
                                              PathUrlAfa().pathRegister,
                                              loadingProvider,
                                            ),
                                            const SizedBox(height: 15),
                                            _buildButton(
                                              context,
                                              'Iniciar sesión',
                                              PathUrlAfa().pathLogin,
                                              loadingProvider,
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Expanded(
                                              child: _buildButton(
                                                context,
                                                'Registrarse',
                                                PathUrlAfa().pathRegister,
                                                loadingProvider,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: _buildButton(
                                                context,
                                                'Iniciar sesión',
                                                PathUrlAfa().pathLogin,
                                                loadingProvider,
                                              ),
                                            ),
                                          ],
                                        );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicMessage() {
    final currentMessage = _messages[_currentMessageIndex];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            currentMessage["icon"],
            color: Colors.blue.shade700,
            size: 36,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              currentMessage["text"].toUpperCase(), // EJEMPLO: en mayúsculas
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26, // más grande
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                letterSpacing: 1.2, // Ejemplo de espaciado de letras
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildButton(
    BuildContext context,
    String text,
    String route,
    LoadingProvider loadingProvider,
  ) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {
        loadingProvider.screenChange();
        context.go(route);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : const Color(0xFF063970),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
      ),
      child: Text(text.toUpperCase()),
    );
  }
}
