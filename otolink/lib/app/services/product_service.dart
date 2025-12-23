import '../models/product.dart';

abstract class ProductService {
  Future<List<Product>> getProducts();

  Future<List<Product>> getProductsByCategory(String categoryId);

  Future<Product?> getProductById(String id);

  Future<void> addProduct(Product product);

  Future<void> deleteProduct(String id);

  Future<void> updateStatus(String id, ProductStatus status);

  Future<void> updateProduct(Product product);
}