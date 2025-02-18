import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false; // Controla la visibilidad de la contraseña

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth * 0.9 > 700 ? 700 : screenWidth * 0.9;

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.blue,
          selectionColor: Colors.blueAccent,
          selectionHandleColor: Colors.blue,
        ),
      ),
      child: Scaffold(
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25, // Aumentado el tamaño de letra
                ),
              ),
            ),
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            // Añadimos padding vertical para que el contenedor no colisione
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Container(
                width: containerWidth,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // PARTE SUPERIOR: Título con fondo azul
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
                        'Registrarse',
                        style: TextStyle(
                          color: Colors.white, // Texto blanco
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // PARTE INFERIOR: Contenido con fondo blanco
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Sección de cuenta
                          _buildTextField(
                            'Correo Electrónico',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 15),
                          _buildTextField('Usuario'),
                          const SizedBox(height: 15),
                          _buildPasswordField(),
                          const SizedBox(height: 20),

                          // Título: Datos personales
                          const Text(
                            'Datos Personales',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Campos: Nombre, Apellidos, Teléfono
                          _buildTextField('Nombre'),
                          const SizedBox(height: 15),
                          _buildTextField('Apellidos'),
                          const SizedBox(height: 15),
                          _buildTextField(
                            'Teléfono',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 20),

                          // Sección de Dirección
                          const Text(
                            'Dirección',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Fila 1: Calle, Ciudad
                          Row(
                            children: [
                              Expanded(child: _buildTextField('Calle')),
                              const SizedBox(width: 15),
                              Expanded(child: _buildTextField('Ciudad')),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Fila 2: Provincia, Código Postal
                          Row(
                            children: [
                              Expanded(child: _buildTextField('Provincia')),
                              const SizedBox(width: 15),
                              Expanded(
                                child: _buildTextField(
                                  'Código Postal',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Botón de registro: Muestra el AlertDialog
                          ElevatedButton(
                            onPressed: () => _showSubmittedDialog(context),
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
                              'Registrarse',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Navegación a inicio de sesión
                          TextButton(
                            onPressed: () {
                              context.go('/inicio-sesion');
                            },
                            child: const Text(
                              '¿Ya tienes cuenta? Inicia sesión',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  // Muestra un AlertDialog indicando que se ha enviado el formulario
  void _showSubmittedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.blue),
              SizedBox(width: 10),
              Text('Formulario enviado'),
            ],
          ),
          content: const Text(
            'Tu solicitud ha sido enviada al administrador. ¡Gracias!',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el AlertDialog
                // Aquí podrías navegar a otra pantalla si lo deseas
                // context.go('/otro-lugar');
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Color del texto del botón
              ),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  // Campos de texto estándar
  Widget _buildTextField(
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      cursorColor: Colors.blue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  // Campo de contraseña
  Widget _buildPasswordField() {
    return TextField(
      cursorColor: Colors.blue,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        filled: true,
        fillColor: Colors.grey[200],
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey),
        ),
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
