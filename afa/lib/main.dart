import 'package:afa/logic/providers/user_active_provider.dart';
import 'package:afa/logic/providers/user_request_provider.dart';
import 'package:afa/design/themes/afa_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:afa/logic/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:afa/logic/providers/user_register_provider.dart';

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
      ],
      child: MaterialApp.router(
        // Cada vez que se construya el child del router se envuelve en LoadingScreen
        builder: (context, child) {
          return LoadingScreen(child: child!);
        },
        theme: AfaTheme(selectedColor: 1).theme(),
        debugShowCheckedModeBanner: false,
        routerConfig: afaRouter,
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  final Widget child;
  const LoadingScreen({Key? key, required this.child}) : super(key: key);
  
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _startLoading();
  }
  
  // Reinicia el estado de carga durante 2 segundos
  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
  
  @override
  void didUpdateWidget(covariant LoadingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el widget hijo cambia, reinicia la pantalla de carga
    if (oldWidget.child != widget.child) {
      _startLoading();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            color: Colors.blue[50],
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          )
        : widget.child;
  }
}
