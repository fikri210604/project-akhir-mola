import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class SearchController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();

  final RxList<String> history = <String>[].obs;
  final RxList<Product> results = <Product>[].obs; 
  final RxString query = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final pref = await SharedPreferences.getInstance();
    final items = pref.getStringList('search_history') ?? <String>[];
    history.assignAll(items);
  }

  Future<void> addHistory(String val) async {
    final q = val.trim();
    if (q.isEmpty) return;
    history.remove(q);
    history.insert(0, q);
    if (history.length > 10) history.removeLast();
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList('search_history', history);
  }

  void clearHistory() async {
    history.clear();
    final pref = await SharedPreferences.getInstance();
    await pref.remove('search_history');
  }

  Future<void> search() async {
    final q = query.value.trim();
    if (q.isEmpty) {
      results.clear();
      return;
    }

    isLoading.value = true;
    try {
      final all = await _productService.getProducts();
      final filtered = all.where((p) => 
        p.title.toLowerCase().contains(q.toLowerCase()) || 
        p.category.name.toLowerCase().contains(q.toLowerCase())
      ).toList();
      
      results.assignAll(filtered);
    } catch (e) {
      results.clear();
    } finally {
      isLoading.value = false;
    }
  }
}