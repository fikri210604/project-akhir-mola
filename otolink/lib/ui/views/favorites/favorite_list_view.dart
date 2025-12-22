import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/favorite_controller.dart';
import '../../../app/routes/routes.dart';
import '../../widgets/ngrok_image.dart';

class FavoriteListView extends GetView<FavoriteController> {
  const FavoriteListView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FavoriteController>()) {
      print("DEBUG_VIEW: Controller belum ada, UI mungkin error");
    } else {
      controller.loadFavoriteProducts();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit Saya"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        automaticallyImplyLeading: false, 
      ),
      backgroundColor: Colors.white,
      body: GetBuilder<FavoriteController>(
        builder: (ctrl) {
          print("DEBUG_VIEW: Rebuild UI. Data Count: ${ctrl.favoriteProducts.length}");

          if (ctrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ctrl.favoriteProducts.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => await ctrl.loadFavoriteProducts(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: Get.height * 0.3),
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("Belum ada favorit"),
                        Text("Pastikan Anda sudah login dan menekan tombol hati"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => await ctrl.loadFavoriteProducts(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: ctrl.favoriteProducts.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final p = ctrl.favoriteProducts[index];
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
                    style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    onPressed: () => ctrl.toggleFavorite(p),
                  ),
                  onTap: () => Get.toNamed(AppRoutes.product, arguments: p.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}