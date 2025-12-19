import 'package:get/get.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _service;
  ProductController(this._service);

  Future<List<Product>> list() => _service.listProducts();
  Future<List<Product>> listByCategory(String categoryId) => _service.listProductsByCategory(categoryId);
  Future<Product?> byId(String id) => _service.getProductById(id);
  Future<Product> add(Product product) => _service.addProduct(product);
}