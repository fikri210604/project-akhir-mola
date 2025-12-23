import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/favorite_service.dart';
import '../controllers/auth_controller.dart'; 
import '../models/product.dart';
import '../services/product_service.dart';

class FavoriteController extends GetxController {
  final FavoriteService _service;
  final AuthController _authController;
  final ProductService _productService;

  FavoriteController(this._service, this._authController, this._productService);

  List<String> favoriteIds = [];
  List<Product> favoriteProducts = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    if (_authController.currentUser.value != null) {
      loadFavoriteProducts();
    }
    
    ever(_authController.currentUser, (user) {
      if (user != null) {
        loadFavoriteProducts();
      } else {
        favoriteIds = [];
        favoriteProducts = [];
        update();
      }
    });
  }

  Future<void> loadFavoriteProducts() async {
    final user = _authController.currentUser.value;
    if (user == null) return;

    isLoading = true;
    update();

    try {
      final ids = await _service.getFavoriteProductIds(user.id);
      favoriteIds = ids;

      final List<Product> products = [];
      for (var id in ids) {
        final p = await _productService.getProductById(id);
        if (p != null) {
          products.add(p);
        }
      }
      
      favoriteProducts = products;
    } catch (e) {
      debugPrint("Error loading favs: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  bool isFav(String productId) {
    return favoriteIds.contains(productId);
  }

  Future<void> toggleFavorite(Product product) async {
    final user = _authController.currentUser.value;
    if (user == null) {
      Get.snackbar('Info', 'Silakan login');
      return;
    }

    if (isFav(product.id)) {
      favoriteIds.remove(product.id);
      favoriteProducts.removeWhere((p) => p.id == product.id);
      update(); 
      
      try {
        await _service.removeFavorite(user.id, product.id);
      } catch (e) {
        loadFavoriteProducts();
      }
    } else {
      favoriteIds.add(product.id);
      if (!favoriteProducts.any((p) => p.id == product.id)) {
        favoriteProducts.add(product);
      }
      update();

      try {
        await _service.addFavorite(user.id, product.id);
      } catch (e) {
        loadFavoriteProducts();
      }
    }
  }
}