import 'package:afa/logic/providers/loading_provider.dart';
import 'package:afa/logic/router/path/path_url_afa.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: true);
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF063970), // Azul oscuro
              Color(0xFF66B3FF), // Azul claro
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: screenWidth * 0.9 > 600 ? 600 : screenWidth * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
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
                // Encabezado con color personalizado
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF063970),
                        Color(0xFF66B3FF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: const Text(
                    '404 - Página no encontrada',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Lo sentimos, la página que buscas no existe o ha sido movida.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          loadingProvider.screenChange();
                          context.go(PathUrlAfa().pathDashboard); 
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF063970), // Azul oscuro
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Volver al inicio',
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
    );
  }
}
