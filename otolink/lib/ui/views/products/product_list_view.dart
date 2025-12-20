import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/models/product.dart';
import '../../../app/controllers/product_controller.dart';
import '../../../app/routes/routes.dart';
import '../../widgets/smart_image.dart';

class ProductListView extends StatelessWidget {
  final String? categoryId;
  final String? categoryName;
  const ProductListView({super.key, this.categoryId, this.categoryName});

  @override
  Widget build(BuildContext context) {
    final productsCtrl = Get.find<ProductController>();
    final Future<List<Product>> future = categoryId == null
        ? productsCtrl.list()
        : productsCtrl.listByCategory(categoryId!);

    return FutureBuilder<List<Product>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        }
        final items = snapshot.data ?? const <Product>[];
        if (items.isEmpty) {
          return const Center(child: Text('Belum ada produk'));
        }
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final p = items[index];
            Widget leading;
            if (p.images.isNotEmpty) {
              leading = ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SmartImage(
                  p.images.first,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              leading = CircleAvatar(child: Text(p.title.isNotEmpty ? p.title[0].toUpperCase() : '?'));
            }
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: leading,
              title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('Rp ${p.price.toStringAsFixed(0)} • ${p.category.name}'),
              onTap: () => Get.toNamed(AppRoutes.product, arguments: p.id),
            );
          },
        );
      },
    );
  }
}