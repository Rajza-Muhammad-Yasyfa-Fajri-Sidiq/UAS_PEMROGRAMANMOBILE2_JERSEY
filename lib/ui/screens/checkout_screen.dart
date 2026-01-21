import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/firestore_service.dart';
import '../../state/auth_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.auth});
  final AuthController auth;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool loading = false;
  String method = 'QRIS';

  @override
  Widget build(BuildContext context) {
    final user = widget.auth.user;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Login dulu untuk checkout.')),
      );
    }
    final uid = user.uid;

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
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
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.payments_rounded, color: cs.primary),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Pembayaran simulasi\n(bonus: ada metode bayar)',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // metode bayar
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.outlineVariant.withOpacity(0.7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Metode Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _payChip(cs, 'QRIS', Icons.qr_code_rounded),
                    _payChip(cs, 'Transfer', Icons.account_balance_rounded),
                    _payChip(cs, 'E-Wallet', Icons.wallet_rounded),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() => loading = true);
                      try {
                        await FirestoreService.createOrderFromCart(uid);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Order created! ($method)')),
                        );
                        context.go('/app/orders');
                      } finally {
                        if (mounted) setState(() => loading = false);
                      }
                    },
              icon: const Icon(Icons.lock_rounded),
              label: Text(loading ? 'Processing...' : 'Pay & Create Order'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Metode dipilih: $method',
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _payChip(ColorScheme cs, String label, IconData icon) {
    final selected = method == label;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => setState(() => method = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? cs.primary.withOpacity(0.14) : cs.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? cs.primary.withOpacity(0.35)
                : cs.outlineVariant.withOpacity(0.7),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? cs.primary : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: selected ? cs.primary : cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
