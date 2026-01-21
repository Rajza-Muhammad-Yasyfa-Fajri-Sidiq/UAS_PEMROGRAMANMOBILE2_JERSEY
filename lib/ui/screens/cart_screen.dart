import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../services/firestore_service.dart';
import '../../state/auth_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.auth});
  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    final uid = auth.user!.uid;
    final rupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart'), centerTitle: true),
      body: StreamBuilder(
        stream: FirestoreService.cartStream(uid),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = (snap.data!).docs;

          if (docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.remove_shopping_cart_rounded,
                      size: 54,
                      color: Colors.black.withOpacity(0.35),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Cart kamu kosong',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Yuk cari jersey dulu di Home.',
                      style: TextStyle(color: Colors.black.withOpacity(0.60)),
                    ),
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: () => context.go('/app/home'),
                      child: const Text('Back to Home'),
                    ),
                  ],
                ),
              ),
            );
          }

          int total = 0;
          for (final doc in docs) {
            final d = doc.data();
            final price = (d['price'] ?? 0) as int;
            final qty = (d['qty'] ?? 1) as int;
            total += price * qty;
          }

          return Stack(
            children: [
              ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final doc = docs[i];
                  final d = doc.data();
                  final name = (d['name'] ?? '-') as String;
                  final imageUrl = (d['imageUrl'] ?? '') as String;
                  final price = (d['price'] ?? 0) as int;
                  final qty = (d['qty'] ?? 1) as int;
                  final size = (d['size'] ?? 'M') as String;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                          color: Colors.black.withOpacity(0.08),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // thumb
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            imageUrl,
                            width: 74,
                            height: 92,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 74,
                              height: 92,
                              color: Colors.black.withOpacity(0.06),
                              child: const Icon(
                                Icons.image_not_supported_rounded,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Size: $size',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.60),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                rupiah.format(price),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        // qty stepper
                        Column(
                          children: [
                            _QtyBtn(
                              icon: Icons.add_rounded,
                              onTap: () =>
                                  FirestoreService.setQty(uid, doc.id, qty + 1),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                '$qty',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            _QtyBtn(
                              icon: Icons.remove_rounded,
                              onTap: () =>
                                  FirestoreService.setQty(uid, doc.id, qty - 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              // bottom checkout bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          offset: const Offset(0, -8),
                          color: Colors.black.withOpacity(0.10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.55),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                rupiah.format(total),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 46,
                          child: FilledButton(
                            onPressed: () => context.push('/checkout'),
                            child: const Text('Checkout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.primary.withOpacity(0.18)),
        ),
        child: Icon(icon, size: 18, color: cs.primary),
      ),
    );
  }
}
