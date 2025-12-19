import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchController extends GetxController {
  final RxList<String> history = <String>[].obs;
  final RxList<String> liveResults = <String>[].obs;

  final List<String> allProducts = const [
    'Motor CBR',
    'Mobil Brio',
    'Vario 160',
    'NMax',
    'PCX',
    'Honda Jazz',
    'Toyota Avanza',
  ];

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

  Future<void> addHistory(String query) async {
    final q = query.trim();
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

  void search(String query) {
    final q = query.trim();
    if (q.isEmpty) {
      liveResults.clear();
      return;
    }
    liveResults.assignAll(
      allProducts.where((e) => e.toLowerCase().contains(q.toLowerCase())),
    );
  }
}