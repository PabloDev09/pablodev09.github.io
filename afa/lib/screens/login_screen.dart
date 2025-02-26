import 'package:afa/path/path_url_afa.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para los campos
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controla la visibilidad de la contraseña
  bool _isPasswordVisible = false;

  // Key para el formulario
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    // Definimos anchos fijos para formulario e imagen y un espacio mínimo
    const double formWidth = 700;
    const double imageWidth = 300;
    const double spacing = 40;
    // Usamos layout en fila solo si el ancho disponible es suficiente
    final bool isLargeScreen = screenWidth >= (formWidth + imageWidth + spacing);

    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF063970),
        elevation: 2,
        shadowColor: Colors.black26,
        leadingWidth: 150,
        leading: TextButton.icon(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          label: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Volver al inicio',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Se envuelve el contenido en un ConstrainedBox con minHeight igual a la altura de la pantalla
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: isLargeScreen
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Formulario (a la izquierda)
                            Container(
                              width: formWidth,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 15,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: _buildLoginForm(),
                            ),
                            // Imagen (a la derecha)
                            Image.asset(
                              'assets/images/logo.png',
                              width: imageWidth,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 15,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: _buildLoginForm(),
                          ),
                          const SizedBox(height: 20),
                          Image.asset(
                            'assets/images/logo.png',
                            width: imageWidth,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // PARTE SUPERIOR: Fondo azul con título
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF063970),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: const Text(
              'Iniciar Sesión',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // PARTE INFERIOR: Fondo blanco con campos y botón
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campo de usuario
                _buildFloatingTextField(
                  label: 'Usuario',
                  hint: 'Ingresa tu usuario',
                  controller: _usernameController,
                ),
                const SizedBox(height: 15),
                // Campo de contraseña
                _buildFloatingPasswordField(),
                const SizedBox(height: 20),
                // Botón de iniciar sesión
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Campos válidos. Iniciando sesión...'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Texto para ir al registro
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.go(PathUrlAfa().pathRegister);
                    },
                    child: const Text(
                      '¿No tienes cuenta? Regístrate',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
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

  // Campo de texto con label flotante
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

  // Campo de contraseña con label flotante y control de visibilidad
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
}
