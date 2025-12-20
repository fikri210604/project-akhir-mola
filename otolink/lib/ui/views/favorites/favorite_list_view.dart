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
  final FavoriteController controller = Get.find<FavoriteController>();

  @override
  void initState() {
    super.initState();
    controller.loadFavoriteProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit Saya"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favoriteProducts.isEmpty) {
          return const Center(child: Text("Belum ada produk favorit"));
        }

        return ListView.separated(
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
                onPressed: () => controller.toggleFavorite(p.id),
              ),
              onTap: () => Get.toNamed(AppRoutes.product, arguments: p.id),
            );
          },
        );
      }),
    );
  }
}