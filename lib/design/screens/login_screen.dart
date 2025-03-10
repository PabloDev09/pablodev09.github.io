import 'dart:ui';
import 'package:afa/logic/providers/loading_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:afa/logic/router/path/path_url_afa.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        context.go(PathUrlAfa().pathDashboard);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión con Google: $e'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildLoginForm(LoadingProvider loadingProvider) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cabecera con degradado y título
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
              'Iniciar sesión',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Cuerpo blanco con campos y botones
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFloatingTextField(
                  label: 'Usuario',
                  hint: 'Ingresa tu usuario',
                  controller: _usernameController,
                ),
                const SizedBox(height: 15),
                _buildFloatingPasswordField(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Campos válidos. Iniciando sesión...'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF063970),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Colors.black12),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      height: 24,
                    ),
                    label: const Text(
                      'Continuar con Google',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: TextButton(
                    onPressed: () {
                      loadingProvider.screenChange();
                      context.go(PathUrlAfa().pathRegister);
                    },
                    child: const Text(
                      '¿No tienes cuenta? Regístrate',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Campo de texto con label flotante
  Widget _buildFloatingTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.blue,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Este campo no puede estar vacío';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(),
      ),
    );
  }

  /// Campo de contraseña con label flotante y control de visibilidad
  Widget _buildFloatingPasswordField() {
    return TextFormField(
      controller: _passwordController,
      cursorColor: Colors.blue,
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Este campo no puede estar vacío';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Contraseña',
        hintText: 'Ingresa tu contraseña',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.blue[700],
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loadingProvider =
        Provider.of<LoadingProvider>(context, listen: true);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth =
        screenWidth * 0.9 > 900 ? 900 : screenWidth * 0.9;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leadingWidth menor para que el hover sea más pequeño
        leadingWidth: 80,
        leading: Tooltip(
          message: 'Volver al inicio',
          child: IconButton(
            onPressed: () {
              loadingProvider.screenChange();
              context.go(PathUrlAfa().pathWelcome);
            },
            // Reemplazamos el icon por la imagen en sí, sin fondo
            icon: Image.asset(
              'assets/images/logo.png',
              width: 80,   // Ajusta el tamaño para hacerlo más grande
              height: 80,  // Ajusta el tamaño para hacerlo más grande
              fit: BoxFit.contain,
            ),
            // Ajustamos el iconSize para que el hover sea más pequeño
            iconSize: 70,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Fondo con mapa + blur
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),
          // Contenedor principal con el formulario
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: containerWidth,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: _buildLoginForm(loadingProvider),
                ),
              ),
            ),
          ),
          // Footer superpuesto (pequeño)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
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
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
