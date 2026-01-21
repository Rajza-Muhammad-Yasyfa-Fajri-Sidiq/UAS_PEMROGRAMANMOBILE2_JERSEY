import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../state/auth_controller.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key, required this.auth});
  final AuthController auth;

  int _safeInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '0') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.user;
    if (user == null) {
      return const Center(child: Text('Login diperlukan untuk melihat order'));
    }

    final uid = user.uid;
    final cs = Theme.of(context).colorScheme;
    final rupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // ✅ Query SIMPLE (tanpa orderBy) -> biasanya TIDAK butuh composite index
    final stream = FirebaseFirestore.instance
        .collection('orders')
        .where('uid', isEqualTo: uid)
        .snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Gagal memuat order:\n${snap.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snap.hasData) {
          return const Center(child: Text('Data belum tersedia'));
        }

        final docs = snap.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text('Belum ada order'));
        }

        // Karena kita tidak orderBy, biar rapi kita sort di client kalau ada createdAt
        docs.sort((a, b) {
          final ad = a.data();
          final bd = b.data();
          final at = ad['createdAt'];
          final bt = bd['createdAt'];

          // kalau Timestamp
          if (at is Timestamp && bt is Timestamp) {
            return bt.compareTo(at); // desc
          }

          // fallback: jangan sort
          return 0;
        });

        return ListView.separated(
          padding: const EdgeInsets.all(14),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final d = docs[i].data();
            final status = (d['status'] ?? '-').toString();
            final total = _safeInt(d['total']);

            return Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant.withOpacity(0.7)),
              ),
              child: ListTile(
                title: Text(
                  'Order • ${status.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text('Total: ${rupiah.format(total)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Status: $status')));
                },
              ),
            );
          },
        );
      },
    );
  }
}
