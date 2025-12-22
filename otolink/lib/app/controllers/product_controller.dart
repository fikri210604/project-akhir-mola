import 'package:get/get.dart';
import 'dart:async';
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
    Future.delayed(Duration.zero, () => loading.value = true);
    try {
      final res = await _service.getProducts();
      products.assignAll(res);
    } catch (e) {
      // ignore
    } finally {
      Future.delayed(Duration.zero, () => loading.value = false);
    }
  }

  Future<List<Product>> list() async {
    return await _service.getProducts();
  }

  Future<List<Product>> listByCategory(String categoryId) async {
    Future.delayed(Duration.zero, () => loading.value = true);
    try {
      final res = await _service.getProductsByCategory(categoryId);
      products.assignAll(res);
      return res;
    } catch (e) {
      return [];
    } finally {
      Future.delayed(Duration.zero, () => loading.value = false);
    }
  }

  Future<Product?> byId(String id) async {
    return await _service.getProductById(id);
  }

  Future<void> add(Product newProduct) async {
    Future.delayed(Duration.zero, () => loading.value = true);
    try {
      await _service.addProduct(newProduct);
      products.insert(0, newProduct);
    } catch (e) {
      rethrow;
    } finally {
      Future.delayed(Duration.zero, () => loading.value = false);
    }
  }
}