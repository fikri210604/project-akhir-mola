import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/favorite_controller.dart';
import '../../../app/routes/routes.dart';
import '../../widgets/ngrok_image.dart';

class FavoriteListView extends StatelessWidget {
  const FavoriteListView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('favorites'.tr),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0.5,
      ),
      body: GetBuilder<FavoriteController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.favoriteProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('no_favorites'.tr),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.favoriteProducts.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, index) {
              final p = controller.favoriteProducts[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 60, 
                    height: 60,
                    child: p.images.isNotEmpty
                      ? NgrokImage(imageUrl: p.images.first, fit: BoxFit.cover)
                      : Container(color: Colors.grey[200], child: const Icon(Icons.image)),
                  ),
                ),
                title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  "Rp ${p.price.toStringAsFixed(0)}", 
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => controller.toggleFavorite(p),
                ),
                onTap: () => Get.toNamed(AppRoutes.product, arguments: p.id),
              );
            },
          );
        },
      ),
    );
  }
}