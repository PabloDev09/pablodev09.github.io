import 'package:afa/operations/router/path/path_url_afa.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth * 0.9 > 500 ? 500 : screenWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Center(
        child: SingleChildScrollView(
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
                // PARTE SUPERIOR: título con fondo azul
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
                    'Bienvenido a AFA Andújar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white, // Texto en blanco
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // PARTE INFERIOR: imagen y botones
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          Image.asset(
                            'assets/images/logo.png',
                            height: 200,
                          ),
                          const SizedBox(height: 30),

                          // Botones
                          constraints.maxWidth < 400
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _buildButton(context, 'Registrarse', PathUrlAfa().pathRegister),
                                    const SizedBox(height: 15),
                                    _buildButton(context, 'Iniciar sesión', PathUrlAfa().pathLogin),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(child: _buildButton(context, 'Registrarse', PathUrlAfa().pathRegister)),
                                    const SizedBox(width: 20),
                                    Expanded(child: _buildButton(context, 'Iniciar sesión', PathUrlAfa().pathLogin)),
                                  ],
                                ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, String route) {
    return ElevatedButton(
      onPressed: () => context.go(route),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
