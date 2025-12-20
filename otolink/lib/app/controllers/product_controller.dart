import 'package:get/get.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'base_controller.dart';

class ProductController extends BaseController {
  final ProductService _service;
  ProductController(this._service);

  final RxList<Product> products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    final list = await runAsync(() => _service.listProducts(), defaultValue: <Product>[]);
    if (list != null) products.assignAll(list);
  }

  Future<List<Product>> list() async {
    return await runAsync(() => _service.listProducts(), defaultValue: <Product>[]) ?? [];
  }

  Future<List<Product>> listByCategory(String categoryId) async {
    return await runAsync(
      () => _service.listProductsByCategory(categoryId),
      timeout: const Duration(seconds: 8),
      defaultValue: <Product>[]
    ) ?? [];
  }

  Future<Product?> byId(String id) async {
    return await runAsync(() => _service.getProductById(id));
  }

  Future<Product?> add(Product product) async {
    return await runAsync(() => _service.addProduct(product));
  }
}