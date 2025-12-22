import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/favorite_controller.dart';
import '../../../app/routes/routes.dart';
import '../../widgets/ngrok_image.dart';

class FavoriteListView extends StatefulWidget {
  const FavoriteListView({super.key});

  @override
  State<FavoriteListView> createState() => _FavoriteListViewState();
}

class _FavoriteListViewState extends State<FavoriteListView> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<FavoriteController>()) {
        Get.find<FavoriteController>().loadFavoriteProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit Saya"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(), 
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: GetBuilder<FavoriteController>(
        init: Get.isRegistered<FavoriteController>() ? Get.find<FavoriteController>() : null,
        builder: (controller) {
          
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.favoriteProducts.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => await controller.loadFavoriteProducts(),
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => await controller.loadFavoriteProducts(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: controller.favoriteProducts.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
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
                    style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    onPressed: () => controller.toggleFavorite(p),
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