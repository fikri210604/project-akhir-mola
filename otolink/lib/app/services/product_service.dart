import '../models/product.dart';

abstract class ProductService {
  Future<List<Product>> listProducts();
  Future<List<Product>> listProductsByCategory(String categoryId);
  Future<Product?> getProductById(String id);
  Future<Product> addProduct(Product product);
}