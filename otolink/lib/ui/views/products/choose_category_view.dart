import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/category_controller.dart';
import '../../../app/models/product_category.dart';
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
    _categoryCtrl.load();
  }

  void _select(ProductCategory c) {
    Get.to(() => AddProductView(initialCategory: c));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Kategori')),
      body: SafeArea(
        child: Obx(() {
          final loading = _categoryCtrl.loading.value;
          final cats = _categoryCtrl.categories;
          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (cats.isEmpty) {
            return const Center(child: Text('Belum ada kategori'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3 / 2,
            ),
            itemCount: cats.length,
            itemBuilder: (context, index) {
              final c = cats[index];
              return InkWell(
                onTap: () => _select(c),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 4),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CategoryIconOptions.iconOf(c.icon), size: 28, color: const Color(0xFF0A2C6C)),
                      const SizedBox(height: 8),
                      Text(
                        c.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

