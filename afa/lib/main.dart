import 'package:afa/operations/providers/user_active_provider.dart';
import 'package:afa/operations/providers/user_request_provider.dart';
import 'package:afa/design/themes/afa_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:afa/operations/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:afa/operations/providers/user_register_provider.dart';

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
        ChangeNotifierProvider(create: (_) => UserActiveProvider()..chargeUsers())
      ],
      child: MaterialApp.router(
        theme: AfaTheme(selectedColor: 1).theme(),
        debugShowCheckedModeBanner: false,
        routerConfig: afaRouter,
      ),
    );
  }
}