import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/auth_controller.dart';
import '../ui/scaffold_with_nav.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/register_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/category_screen.dart';
import '../ui/screens/jersey_detail_screen.dart';
import '../ui/screens/favorites_screen.dart';
import '../ui/screens/cart_screen.dart';
import '../ui/screens/checkout_screen.dart';
import '../ui/screens/orders_screen.dart';
import '../ui/screens/about_screen.dart';
import '../ui/screens/info_screen.dart';

GoRouter buildRouter(AuthController auth) {
  final rootKey = GlobalKey<NavigatorState>();
  final shellKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootKey,
    refreshListenable: auth,
    initialLocation: '/app/home',
    redirect: (context, state) {
      final loggedIn = auth.isLoggedIn;
      final loc = state.matchedLocation;

      final isAuth = (loc == '/login' || loc == '/register');

      if (!loggedIn && !isAuth) return '/login';
      if (loggedIn && isAuth) return '/app/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => LoginScreen(auth: auth),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => RegisterScreen(auth: auth),
      ),

      // Detail & Checkout di luar bottom-nav (full screen)
      GoRoute(
        path: '/detail/:id',
        builder: (_, s) =>
            JerseyDetailScreen(auth: auth, id: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/checkout',
        builder: (_, __) => CheckoutScreen(auth: auth),
      ),

      GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
      GoRoute(path: '/info', builder: (_, __) => const InfoScreen()),

      // Shell (BottomNav)
      ShellRoute(
        navigatorKey: shellKey,
        builder: (context, state, child) => ScaffoldWithNav(child: child),
        routes: [
          GoRoute(path: '/app/home', builder: (_, __) => const HomeScreen()),
          GoRoute(
            path: '/app/category/:team',
            builder: (_, s) => CategoryScreen(team: s.pathParameters['team']!),
          ),
          GoRoute(
            path: '/app/favorites',
            builder: (_, __) => FavoritesScreen(auth: auth),
          ),
          GoRoute(
            path: '/app/cart',
            builder: (_, __) => CartScreen(auth: auth),
          ),
          GoRoute(
            path: '/app/orders',
            builder: (_, __) => OrdersScreen(auth: auth),
          ),
        ],
      ),
    ],
  );
}
