import 'package:get/get.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _service;
  ProductController(this._service);

  final products = <Product>[].obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshProducts();
  }

  Future<void> refreshProducts() async {
    loading.value = true;
    try {
      final res = await _service.listProducts();
      products.assignAll(res);
    } catch (e) {
    } finally {
      loading.value = false;
    }
  }

  Future<void> listByCategory(String categoryId) async {
    loading.value = true;
    try {
      final res = await _service.listProductsByCategory(categoryId);
      products.assignAll(res);
    } finally {
      loading.value = false;
    }
  }

  Future<Product?> byId(String id) => _service.getProductById(id);

  Future<void> add(Product product) async {
    final newProduct = await _service.addProduct(product);
    products.insert(0, newProduct);
  }
}