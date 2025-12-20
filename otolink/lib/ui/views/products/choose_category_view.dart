import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/category_controller.dart';
import '../../utils/category_icon_options.dart';
import 'add_product_view.dart';

class ChooseCategoryView extends StatefulWidget {
  const ChooseCategoryView({super.key});

  @override
  State<ChooseCategoryView> createState() => _ChooseCategoryViewState();
}

class _ChooseCategoryViewState extends State<ChooseCategoryView> {
  late final CategoryController _categoryCtrl;

  @override
  void initState() {
    super.initState();
    _categoryCtrl = Get.find<CategoryController>();
    if (_categoryCtrl.categories.isEmpty) {
      _categoryCtrl.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Kategori')),
      body: Obx(() {
        final cats = _categoryCtrl.categories;
        if (_categoryCtrl.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: cats.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final c = cats[index];
            return ListTile(
              leading: Icon(CategoryIconOptions.iconOf(c.icon), color: const Color(0xFF0A2C6C)),
              title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                Get.to(() => AddProductView(initialCategory: c));
              },
            );
          },
        );
      }),
    );
  }
}