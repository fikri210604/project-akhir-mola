import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      print("Error loading products: $e");
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
      products.insert(0, newProduct);
      products.refresh();
    } catch (e) {
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteProduct(String productId) async {
    loading.value = true;
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();
      
      products.removeWhere((p) => p.id == productId);
      products.refresh();
      
      Get.snackbar('Sukses', 'Produk berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus produk: $e');
    } finally {
      loading.value = false;
    }
  }
}