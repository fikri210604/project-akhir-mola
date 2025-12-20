import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/product_controller.dart';
import '../../../app/controllers/chat_controller.dart';
import '../../../app/controllers/auth_controller.dart';
import '../../../app/routes/routes.dart';
import '../../widgets/ngrok_image.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  String _formatCurrency(double price) {
    final str = price.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp $buffer';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final String productId = Get.arguments;
    final productCtrl = Get.find<ProductController>();
    final chatCtrl = Get.find<ChatController>();
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
      body: FutureBuilder(
        future: productCtrl.byId(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Produk tidak ditemukan'));
          }

          final p = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (p.images.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      itemCount: p.images.length,
                      itemBuilder: (context, index) {
                        return NgrokImage(
                          imageUrl: p.images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                Text('Gagal memuat gambar', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    height: 300,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatCurrency(p.price),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(p.location ?? 'Lokasi tidak tersedia', style: const TextStyle(color: Colors.grey)),
                          const Spacer(),
                          Text(_formatDate(p.createdAt), style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const Divider(height: 32),
                      const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(p.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                      
                      const Divider(height: 32),
                      const Text('Detail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildDetailRow('Kategori', p.category.name),
                      if (p.year != null) _buildDetailRow('Tahun', p.year.year.toString()),
                      ...p.attributes.entries.map((e) => _buildDetailRow(e.key, e.value.toString())),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: ElevatedButton.icon(
          onPressed: () async {
            final currentUser = authCtrl.currentUser.value;
            if (currentUser == null) {
              Get.toNamed(AppRoutes.login);
              return;
            }
            
            final p = await productCtrl.byId(productId);
            if (p == null) return;

            if (p.sellerId == currentUser.id) {
              Get.snackbar('Info', 'Ini produk Anda sendiri');
              return;
            }

            try {
              final thread = await chatCtrl.createThread(p.sellerId);
              Get.toNamed(AppRoutes.chatRoom, arguments: thread.id);
            } catch (e) {
              Get.snackbar('Error', 'Gagal memulai chat: $e');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          icon: const Icon(Icons.chat),
          label: const Text('Chat Penjual'),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}