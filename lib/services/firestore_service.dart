import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/jersey.dart';

extension JerseyMiniExt on Jersey {
  Map<String, dynamic> toMiniMap() => {
    'id': id,
    'name': name,
    'team': team,
    'price': price,
    'imageUrl': imageUrl,
  };
}

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> _favCol(String uid) =>
      _db.collection('users').doc(uid).collection('favorites');

  static CollectionReference<Map<String, dynamic>> _cartCol(String uid) =>
      _db.collection('users').doc(uid).collection('cart');

  static Stream<QuerySnapshot<Map<String, dynamic>>> favoritesStream(
    String uid,
  ) => _favCol(uid).orderBy('createdAt', descending: true).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> cartStream(String uid) =>
      _cartCol(uid).orderBy('createdAt', descending: true).snapshots();

  static Future<void> toggleFavorite(String uid, Jersey jersey) async {
    final ref = _favCol(uid).doc(jersey.id);
    final snap = await ref.get();
    if (snap.exists) {
      await ref.delete();
    } else {
      await ref.set({
        ...jersey.toMiniMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> addToCart(
    String uid,
    Jersey jersey, {
    String size = 'M',
  }) async {
    final ref = _cartCol(uid).doc(jersey.id);
    final snap = await ref.get();
    if (snap.exists) {
      final qty = (snap.data()?['qty'] ?? 1) as int;
      await ref.update({'qty': qty + 1});
    } else {
      await ref.set({
        ...jersey.toMiniMap(),
        'qty': 1,
        'size': size,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> setQty(String uid, String jerseyId, int qty) async {
    final ref = _cartCol(uid).doc(jerseyId);
    if (qty <= 0) {
      await ref.delete();
    } else {
      await ref.update({'qty': qty});
    }
  }

  static Future<void> clearCart(String uid) async {
    final snap = await _cartCol(uid).get();
    for (final d in snap.docs) {
      await d.reference.delete();
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> ordersStream(String uid) =>
      _db
          .collection('orders')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots();

  static Future<void> createOrderFromCart(String uid) async {
    final cartSnap = await _cartCol(uid).get();
    final items = cartSnap.docs.map((d) => d.data()).toList();

    int total = 0;
    for (final it in items) {
      total += ((it['price'] ?? 0) as int) * ((it['qty'] ?? 1) as int);
    }

    await _db.collection('orders').add({
      'uid': uid,
      'items': items,
      'total': total,
      'status': 'PAID',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await clearCart(uid);
  }
}
