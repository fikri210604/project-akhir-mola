import 'package:get/get.dart';
import '../models/product_category.dart';
import '../models/category_field.dart';
import '../services/category_service.dart';
import 'base_controller.dart';

class CategoryController extends BaseController {
  final CategoryService _service;
  CategoryController(this._service);

  final RxList<ProductCategory> categories = <ProductCategory>[].obs;
  final RxList<CategoryField> fields = <CategoryField>[].obs;
  
  final RxBool fieldsLoading = false.obs;

  Future<void> load() async {
    final list = await runAsync(
      () => _service.listCategories(),
      timeout: const Duration(seconds: 8),
      defaultValue: <ProductCategory>[]
    );
    
    if (list != null && list.isNotEmpty) {
      categories.assignAll(list);
    } else {
      categories.assignAll(_defaultCategories());
    }
  }

  Future<void> loadFieldsFor(String categoryId) async {
    fieldsLoading.value = true;
    try {
      final list = await _service.listFields(categoryId);
      fields.assignAll(list);
    } catch (e) {
      fields.clear();
    } finally {
      fieldsLoading.value = false;
    }
  }

  List<ProductCategory> _defaultCategories() => const [
        ProductCategory(id: 'laptop', name: 'Laptop', icon: 'device_laptop'),
        ProductCategory(id: 'handphone', name: 'Handphone', icon: 'phone'),
        ProductCategory(id: 'motor', name: 'Motor', icon: 'car'),
        ProductCategory(id: 'mobil', name: 'Mobil', icon: 'car'),
      ];
}