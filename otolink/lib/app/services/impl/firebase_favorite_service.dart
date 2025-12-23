import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../favorite_service.dart';

class FirebaseFavoriteService implements FavoriteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _favs(String userId) => 
      _db.collection('users').doc(userId).collection('favorites');

  @override
  Future<void> addFavorite(String userId, String productId) async {
    debugPrint("LOG_DB: Attempting to add favorite -> User: $userId, Product: $productId");
    try {
      await _favs(userId).doc(productId).set({
        'productId': productId,
        'addedAt': FieldValue.serverTimestamp(),
      });
      debugPrint("LOG_DB: Success add favorite");
    } catch (e) {
      debugPrint("LOG_DB: Error add favorite: $e");
      rethrow;
    }
  }

  @override
  Future<void> removeFavorite(String userId, String productId) async {
    debugPrint("LOG_DB: Attempting to remove favorite -> User: $userId, Product: $productId");
    try {
      await _favs(userId).doc(productId).delete();
      debugPrint("LOG_DB: Success remove favorite");
    } catch (e) {
      debugPrint("LOG_DB: Error remove favorite: $e");
      rethrow;
    }
  }

  @override
  Future<bool> isFavorite(String userId, String productId) async {
    try {
      final doc = await _favs(userId).doc(productId).get();
      return doc.exists;
    } catch (e) {
      debugPrint("LOG_DB: Error checking favorite: $e");
      return false;
    }
  }

  @override
  Future<List<String>> getFavoriteProductIds(String userId) async {
    debugPrint("LOG_DB: Fetching favorite IDs for user: $userId");
    try {
      final snap = await _favs(userId).orderBy('addedAt', descending: true).get();
      final ids = snap.docs.map((d) => d.id).toList();
      debugPrint("LOG_DB: Found ${ids.length} favorite IDs: $ids");
      return ids;
    } catch (e) {
      debugPrint("LOG_DB: Error fetching IDs: $e");
      return [];
    }
  }
}