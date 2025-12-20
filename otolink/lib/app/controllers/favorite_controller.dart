import 'package:get/get.dart';
import '../services/favorite_service.dart';
import '../services/auth_service.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class FavoriteController extends GetxController {
  final FavoriteService _service;
  final AuthService _authService;
  final ProductService _productService;

  FavoriteController(this._service, this._authService, this._productService);

  final RxList<String> favoriteIds = <String>[].obs;
  final RxList<Product> favoriteProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final user = _authService.currentUser;
    if (user == null) return;

    try {
      final ids = await _service.getFavoriteProductIds(user.id);
      favoriteIds.assignAll(ids);
    } catch (e) {
    }
  }

  Future<void> loadFavoriteProducts() async {
    final user = _authService.currentUser;
    if (user == null) return;

    isLoading.value = true;
    try {
      final ids = await _service.getFavoriteProductIds(user.id);
      favoriteIds.assignAll(ids);

      final List<Product> products = [];
      for (var id in ids) {
        final p = await _productService.getProductById(id);
        if (p != null) products.add(p);
      }
      favoriteProducts.assignAll(products);
    } finally {
      isLoading.value = false;
    }
  }

  bool isFav(String productId) {
    return favoriteIds.contains(productId);
  }

  Future<void> toggleFavorite(String productId) async {
    final user = _authService.currentUser;
    if (user == null) {
      Get.snackbar('Info', 'Silakan login untuk menyimpan favorit');
      return;
    }

    if (isFav(productId)) {
      favoriteIds.remove(productId);
      await _service.removeFavorite(user.id, productId);
      favoriteProducts.removeWhere((p) => p.id == productId);
    } else {
      favoriteIds.add(productId);
      await _service.addFavorite(user.id, productId);
    }
  }
}