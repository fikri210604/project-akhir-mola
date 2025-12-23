import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _service;
  
  ProductController(this._service);

  final RxList<Product> products = <Product>[].obs;
  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshProducts();
  }

  Future<void> refreshProducts() async {
    loading.value = true;
    try {
      final res = await _service.getProducts();
      products.assignAll(res);
    } catch (e) {
      debugPrint("Error loading products: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<List<Product>> list() async {
    return await _service.getProducts();
  }

  Future<List<Product>> listByCategory(String categoryId) async {
    loading.value = true;
    try {
      final res = await _service.getProductsByCategory(categoryId);
      products.assignAll(res);
      return res;
    } catch (e) {
      return [];
    } finally {
      loading.value = false;
    }
  }

  Future<Product?> byId(String id) async {
    return await _service.getProductById(id);
  }

  Future<void> add(Product newProduct) async {
    loading.value = true;
    try {
      await _service.addProduct(newProduct);
      refreshProducts();
    } catch (e) {
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  Future<void> edit(Product updatedProduct) async {
    loading.value = true;
    try {
      await _service.updateProduct(updatedProduct);
      final index = products.indexWhere((p) => p.id == updatedProduct.id);
      if (index != -1) {
        products[index] = updatedProduct;
        products.refresh();
      }
    } catch (e) {
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteProduct(String productId) async {
    loading.value = true;
    try {
      await _service.deleteProduct(productId);
      products.removeWhere((p) => p.id == productId);
    } catch (e) {
      debugPrint("Error deleting product: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> markAsSold(String productId) async {
    try {
      await _service.updateStatus(productId, ProductStatus.sold);
      final index = products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        final old = products[index];
        products[index] = Product(
          id: old.id,
          title: old.title,
          description: old.description,
          price: old.price,
          category: old.category,
          brands: old.brands,
          images: old.images,
          year: old.year,
          sellerId: old.sellerId,
          createdAt: old.createdAt,
          location: old.location,
          attributes: old.attributes,
          status: ProductStatus.sold,
        );
        products.refresh();
      }
    } catch (e) {
      debugPrint("Error updating status: $e");
      Get.snackbar('Error', 'Gagal memperbarui status produk');
    }
  }
}