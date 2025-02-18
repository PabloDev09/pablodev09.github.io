import 'package:go_router/go_router.dart';
import 'package:afa/screens/welcome_screen.dart';
import 'package:afa/screens/login_screen.dart';
import 'package:afa/screens/register_screen.dart';
import 'package:afa/screens/not_found_screen.dart';

final GoRouter afaRouter = GoRouter(
    initialLocation: '/', // Página de inicio
     routes: <RouteBase>
     [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/inicio-sesion',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/registro',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );