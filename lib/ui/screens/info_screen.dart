import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget item(IconData icon, String title, String subtitle) => Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.7)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Informasi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cs.primary.withOpacity(0.18)),
            ),
            child: const Text(
              'Stack aplikasi ini (sesuai requirement tugas):',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 12),
          item(
            Icons.lock_rounded,
            'Login & Register',
            'Firebase Authentication',
          ),
          const SizedBox(height: 10),
          item(
            Icons.favorite_rounded,
            'Favorites',
            'Cloud Firestore (subcollection users/{uid}/favorites)',
          ),
          const SizedBox(height: 10),
          item(
            Icons.shopping_cart_rounded,
            'Cart',
            'Cloud Firestore (subcollection users/{uid}/cart)',
          ),
          const SizedBox(height: 10),
          item(
            Icons.receipt_long_rounded,
            'Orders',
            'Cloud Firestore (collection orders)',
          ),
          const SizedBox(height: 10),
          item(Icons.public_rounded, 'Catalog & Detail', 'REST API (MockAPI)'),
        ],
      ),
    );
  }
}
