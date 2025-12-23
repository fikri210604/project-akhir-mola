import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/category_icon_options.dart';
import '../../../app/controllers/category_controller.dart';

class ChooseCategoryView extends StatelessWidget {
  const ChooseCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CategoryController>();
    if (ctrl.categories.isEmpty) ctrl.load();

    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Kategori')),
      body: Obx(() {
        if (ctrl.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: ctrl.categories.length,
          itemBuilder: (_, index) {
            final cat = ctrl.categories[index];
            return ListTile(
              leading: Icon(CategoryIconOptions.iconOf(cat.icon)),
              title: Text(cat.name),
              onTap: () {
                Get.back(result: cat);
              },
            );
          },
        );
      }),
    );
  }
}