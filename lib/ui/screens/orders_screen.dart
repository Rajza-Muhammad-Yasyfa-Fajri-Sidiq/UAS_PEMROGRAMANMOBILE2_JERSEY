import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../state/auth_controller.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key, required this.auth});
  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    final uid = auth.user!.uid;

    return StreamBuilder(
      stream: FirestoreService.ordersStream(uid),
      builder: (context, snap) {
        if (!snap.hasData)
          return const Center(child: CircularProgressIndicator());
        final docs = (snap.data!).docs;
        if (docs.isEmpty) return const Center(child: Text('Belum ada order'));

        return ListView.separated(
          padding: const EdgeInsets.all(14),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final d = docs[i].data();
            return ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Order • ${d['status'] ?? '-'}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text('Total: Rp ${d['total'] ?? 0}'),
              trailing: const Icon(Icons.chevron_right),
            );
          },
        );
      },
    );
  }
}
