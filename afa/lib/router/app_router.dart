import 'package:afa/screens/dashboard_screen.dart';
import 'package:afa/screens/login_screen.dart';
import 'package:afa/screens/not_found_screen.dart';
import 'package:afa/screens/pending_user_screen.dart';
import 'package:afa/screens/register_screen.dart';
import 'package:afa/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

bool isAuthenticated() {
  final user = FirebaseAuth.instance.currentUser;
  return user != null; 
}

final GoRouter afaRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
      redirect: (context, state) {
        if (!isAuthenticated()) return '/login';
        return null;
      },
    ),
    GoRoute(
      path: '/pending',
      name: 'pending',
      builder: (context, state) => const PendingUsersScreen(),
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
