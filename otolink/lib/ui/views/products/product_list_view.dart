import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/product_controller.dart';
import '../../../app/routes/routes.dart';
import '../../widgets/ngrok_image.dart';

class ProductListView extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  const ProductListView({super.key, this.categoryId, this.categoryName});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final productsCtrl = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      productsCtrl.listByCategory(widget.categoryId!);
    } else {
      productsCtrl.refreshProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (productsCtrl.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      final items = productsCtrl.products;
      
      if (items.isEmpty) {
        return const Center(child: Text('Belum ada produk'));
      }
      
      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        padding: const EdgeInsets.only(bottom: 20),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final p = items[index];
          Widget leading;
          
          if (p.images.isNotEmpty) {
            leading = ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NgrokImage(
                imageUrl: p.images.first,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            );
          } else {
            leading = CircleAvatar(
              backgroundColor: Colors.indigo.shade100,
              child: Text(
                p.title.isNotEmpty ? p.title[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.indigo),
              ),
            );
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
    });
  }
}