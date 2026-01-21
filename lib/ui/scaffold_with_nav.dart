import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key, required this.child});
  final Widget child;

  int _indexFromLoc(String loc) {
    if (loc.startsWith('/app/favorites')) return 1;
    if (loc.startsWith('/app/cart')) return 2;
    if (loc.startsWith('/app/orders')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final idx = _indexFromLoc(loc);

    return Scaffold(
      appBar: AppBar(
        title: const Text('JerseyHub'),
        actions: [
          IconButton(
            onPressed: () => context.push('/about'),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/app/home');
              break;
            case 1:
              context.go('/app/favorites');
              break;
            case 2:
              context.go('/app/cart');
              break;
            case 3:
              context.go('/app/orders');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            label: 'Fav',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
