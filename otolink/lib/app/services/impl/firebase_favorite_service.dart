import 'package:cloud_firestore/cloud_firestore.dart';
import '../favorite_service.dart';

class FirebaseFavoriteService implements FavoriteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _favs(String userId) => 
      _db.collection('users').doc(userId).collection('favorites');

  @override
  Future<void> addFavorite(String userId, String productId) async {
    await _favs(userId).doc(productId).set({
      'productId': productId,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeFavorite(String userId, String productId) async {
    await _favs(userId).doc(productId).delete();
  }

  @override
  Future<bool> isFavorite(String userId, String productId) async {
    final doc = await _favs(userId).doc(productId).get();
    return doc.exists;
  }

  @override
  Future<List<String>> getFavoriteProductIds(String userId) async {
    final snap = await _favs(userId).orderBy('addedAt', descending: true).get();
    return snap.docs.map((d) => d.id).toList();
  }
}