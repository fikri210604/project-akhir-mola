import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/product_controller.dart';
import '../../../app/controllers/auth_controller.dart';
import '../../../app/routes/routes.dart';
import '../../widgets/ngrok_image.dart';

class MyProductsView extends StatelessWidget {
  const MyProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final productCtrl = Get.find<ProductController>();
    final authCtrl = Get.find<AuthController>();
    final myId = authCtrl.currentUser.value?.id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Produk Saya"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        final myProducts = productCtrl.products.where((p) => p.sellerId == myId).toList();

        if (productCtrl.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (myProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text("Anda belum menjual produk apapun"),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: myProducts.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final p = myProducts[index];
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
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  Get.defaultDialog(
                    title: "Hapus Produk",
                    middleText: "Apakah Anda yakin ingin menghapus produk ini?",
                    textConfirm: "Hapus",
                    textCancel: "Batal",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () async {
                      Get.back();
                      await productCtrl.deleteProduct(p.id);
                    }
                  );
                },
              ),
              onTap: () => Get.toNamed(AppRoutes.product, arguments: p.id),
            );
          },
        );
      }),
    );
  }
}