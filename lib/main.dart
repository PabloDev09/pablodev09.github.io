import 'package:afa/logic/providers/loading_provider.dart';
import 'package:afa/logic/providers/theme_provider.dart';
import 'package:afa/logic/providers/user_active_provider.dart';
import 'package:afa/logic/providers/user_request_provider.dart';
import 'package:afa/design/themes/afa_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:afa/logic/router/afa_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:afa/logic/providers/user_register_provider.dart';
import 'dart:ui'; // Para el uso de BackdropFilter si lo necesitaras


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setUrlStrategy(PathUrlStrategy());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserRegisterProvider()),
        ChangeNotifierProvider(create: (_) => UserRequestProvider()..chargeUsers()),
        ChangeNotifierProvider(create: (_) => UserActiveProvider()..chargeUsers()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            builder: (context, child) {
              return LoadingScreen(child: child!);
            },
            theme: AfaTheme.theme(
              themeProvider.isDarkMode, 
              1
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: afaRouter,
          );
        },
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  final Widget child;

  const LoadingScreen({super.key, required this.child});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;

  // Controlador y animación para el autobús
  late AnimationController _busController;
  late Animation<double> _busAnimation;

  @override
  void initState() {
    super.initState();
    // Controlador que repetirá la animación de forma indefinida
    _busController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Tween que mapea de -1.0 a 1.0 (recorrerá la pantalla de izquierda a derecha)
    _busAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _busController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _busController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkLoadingState();
  }

  void _checkLoadingState() {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: true);
    
    if (loadingProvider.isScreenChange) {
      setState(() {
        _isLoading = true;
      });

      // Simula 2 segundos de "pantalla de carga"
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF063970), Color(0xFF66B3FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Contenido centrado (logo + CircularProgressIndicator)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
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
                          width: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 6,
                      ),
                    ],
                  ),
                ),

                // Autobús animado recorriendo la pantalla
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _busAnimation,
                    builder: (context, child) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      // Ajusta el ancho que ocupará el autobús
                      const busWidth = 100.0;

                      // Calcula la posición X basándote en la animación
                      // Moverá el autobús desde -busWidth hasta (screenWidth + busWidth)
                      final xPos = -busWidth + _busAnimation.value * (screenWidth + busWidth * 2);

                      return Transform.translate(
                        offset: Offset(xPos, 0),
                        // Lo alineamos en la parte inferior
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Image.asset(
                            'assets/images/bus.png', // Tu imagen de autobús
                            width: busWidth,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : widget.child;
  }
}
