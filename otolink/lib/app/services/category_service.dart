import '../models/product_category.dart';
import '../models/category_field.dart';

abstract class CategoryService {
  Future<List<ProductCategory>> listCategories();
  Future<ProductCategory> createCategory({required String name, required String icon});
  Future<List<CategoryField>> listFields(String categoryId);
}