import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/product_controller.dart';
import '../../../app/controllers/auth_controller.dart';
import '../../../app/models/product.dart';
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
                const Text("Belum ada produk yang dijual", style: TextStyle(color: Colors.grey)),
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
            final isSold = p.status == ProductStatus.sold;

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      p.images.isNotEmpty
                          ? NgrokImage(imageUrl: p.images.first, fit: BoxFit.cover)
                          : Container(color: Colors.grey[200], child: const Icon(Icons.image)),
                      if (isSold)
                        Container(
                          color: Colors.black54,
                          alignment: Alignment.center,
                          child: const Text(
                            "SOLD",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              title: Text(
                p.title, 
                maxLines: 1, 
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: isSold ? TextDecoration.lineThrough : null,
                  color: isSold ? Colors.grey : Colors.black,
                ),
              ),
              subtitle: Text(
                "Rp ${p.price.toStringAsFixed(0)}",
                style: TextStyle(
                  color: isSold ? Colors.grey : Colors.indigo, 
                  fontWeight: FontWeight.bold
                ),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    Get.toNamed(AppRoutes.editProduct, arguments: p); 
                  } else if (value == 'sold') {
                    Get.defaultDialog(
                      title: "Konfirmasi",
                      middleText: "Tandai produk ini sebagai terjual?",
                      textConfirm: "Ya, Terjual",
                      textCancel: "Batal",
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.back();
                        productCtrl.markAsSold(p.id);
                      },
                    );
                  } else if (value == 'delete') {
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
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  if (!isSold)
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Edit Produk'),
                        ],
                      ),
                    ),
                  if (!isSold)
                    const PopupMenuItem<String>(
                      value: 'sold',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Tandai Terjual'),
                        ],
                      ),
                    ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus Produk'),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () => Get.toNamed(AppRoutes.product, arguments: p.id),
            );
          },
        );
      }),
    );
  }
}