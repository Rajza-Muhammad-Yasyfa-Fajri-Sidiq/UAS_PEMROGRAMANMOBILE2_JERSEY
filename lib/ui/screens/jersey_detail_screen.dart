import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/jersey.dart';
import '../../services/api_service.dart';
import '../../services/firestore_service.dart';
import '../../state/auth_controller.dart';

class JerseyDetailScreen extends StatefulWidget {
  const JerseyDetailScreen({super.key, required this.auth, required this.id});
  final AuthController auth;
  final String id;

  @override
  State<JerseyDetailScreen> createState() => _JerseyDetailScreenState();
}

class _JerseyDetailScreenState extends State<JerseyDetailScreen> {
  String _size = 'M';

  @override
  Widget build(BuildContext context) {
    final rupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return FutureBuilder<Jersey>(
      future: ApiService.getJerseyById(widget.id),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError || !snap.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: ${snap.error}')),
          );
        }

        final j = snap.data!;
        final uid = widget.auth.user!.uid;
        final cs = Theme.of(context).colorScheme;

        return Scaffold(
          bottomNavigationBar: SafeArea(
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
                          rupiah.format(j.price),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 46,
                    child: FilledButton.icon(
                      onPressed: () async {
                        await FirestoreService.addToCart(uid, j, size: _size);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added to cart (Size $_size)'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag_rounded),
                      label: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 360,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                actions: [
                  // Favorite realtime: cek apakah doc favorite ada
                  StreamBuilder(
                    stream: FirestoreService.favoritesStream(uid),
                    builder: (context, favSnap) {
                      bool isFav = false;
                      if (favSnap.hasData) {
                        isFav = favSnap.data!.docs.any((d) => d.id == j.id);
                      }
                      return IconButton(
                        onPressed: () async {
                          await FirestoreService.toggleFavorite(uid, j);
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFav
                                    ? 'Removed from favorites'
                                    : 'Added to favorites',
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'jersey-${j.id}',
                        child: CachedNetworkImage(
                          imageUrl: j.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: Colors.black.withOpacity(0.06),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.black.withOpacity(0.06),
                            child: const Center(
                              child: Icon(Icons.image_not_supported_rounded),
                            ),
                          ),
                        ),
                      ),
                      // Gradient overlay biar teks kebaca
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.70),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),

                      // Badge rating + season (di bawah kiri)
                      Positioned(
                        left: 16,
                        bottom: 18,
                        right: 16,
                        child: Row(
                          children: [
                            _Badge(
                              icon: Icons.star_rounded,
                              text: j.rating.toStringAsFixed(1),
                              color: Colors.white,
                              bg: Colors.white.withOpacity(0.22),
                            ),
                            const SizedBox(width: 8),
                            _Badge(
                              icon: Icons.calendar_month_rounded,
                              text: j.season,
                              color: Colors.white,
                              bg: Colors.white.withOpacity(0.22),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: cs.primary.withOpacity(0.92),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Official Store',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        j.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${j.team} • ${j.league}',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.62),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Price card + info
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cs.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: cs.primary.withOpacity(0.16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.payments_rounded, color: cs.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                rupiah.format(j.price),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Ready',
                                style: TextStyle(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Size selector
                      const Text(
                        'Choose Size',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: ['S', 'M', 'L', 'XL'].map((s) {
                          final selected = _size == s;
                          return InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => setState(() => _size = s),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? cs.primary.withOpacity(0.14)
                                    : Colors.black.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected
                                      ? cs.primary.withOpacity(0.35)
                                      : Colors.black.withOpacity(0.06),
                                ),
                              ),
                              child: Text(
                                s,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: selected ? cs.primary : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        j.description,
                        style: TextStyle(
                          height: 1.35,
                          color: Colors.black.withOpacity(0.70),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Quick actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.go('/app/cart'),
                              icon: const Icon(Icons.shopping_cart_rounded),
                              label: const Text('Go to Cart'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Share coming soon'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.share_rounded),
                              label: const Text('Share'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color bg;

  const _Badge({
    required this.icon,
    required this.text,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
