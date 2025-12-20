abstract class FavoriteService {
  Future<void> addFavorite(String userId, String productId);
  Future<void> removeFavorite(String userId, String productId);
  Future<bool> isFavorite(String userId, String productId);
  Future<List<String>> getFavoriteProductIds(String userId);
}