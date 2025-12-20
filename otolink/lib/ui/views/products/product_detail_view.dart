import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/product_controller.dart';
import '../../../app/controllers/chat_controller.dart';
import '../../../app/controllers/auth_controller.dart';
import '../../../app/controllers/favorite_controller.dart';
import '../../../app/models/product.dart';
import '../../../app/routes/routes.dart';
import '../../widgets/ngrok_image.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> with SingleTickerProviderStateMixin {
  final PageController _pageCtrl = PageController();
  late AnimationController _favAnimCtrl;
  late Animation<double> _favScaleAnim;
  
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _favAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _favScaleAnim = Tween<double>(begin: 1.0, end: 1.4).animate(_favAnimCtrl);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _favAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments;
    if (id is! String) return const Scaffold(body: Center(child: Text("Produk tidak ditemukan")));

    final ctrl = Get.find<ProductController>();
    final favCtrl = Get.find<FavoriteController>();

    return FutureBuilder<Product?>(
      future: ctrl.byId(id),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final p = snap.data;
        if (p == null) return const Scaffold(body: Center(child: Text("Produk tidak ditemukan")));

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Detail Produk"),
            centerTitle: true,
            elevation: 0.3,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            actions: [
              IconButton(icon: const Icon(Icons.share), onPressed: () {}),
              
              Obx(() {
                final isFav = favCtrl.isFav(p.id);
                return GestureDetector(
                  onTap: () async {
                    await _favAnimCtrl.forward().then((_) => _favAnimCtrl.reverse());
                    favCtrl.toggleFavorite(p.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ScaleTransition(
                      scale: _favScaleAnim.drive(Tween(begin: 1.0, end: 1.5)),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.pink : Colors.grey,
                        size: 26,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarousel(p.images),
                const SizedBox(height: 20),
                _buildPriceSection(p),
                const Divider(height: 32),
                _buildLocation(p),
                const Divider(height: 32),
                _buildDetailSpecs(p),
                const Divider(height: 32),
                _buildDescription(p),
                const Divider(height: 32),
                _buildSeller(p),
                const SizedBox(height: 20),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(p),
        );
      },
    );
  }

  Widget _buildCarousel(List<String> images) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Stack(
        children: [
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            ),
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: images.isEmpty ? 1 : images.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) {
                if (images.isEmpty) {
                  return Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image, size: 64, color: Colors.grey),
                  );
                }
                return NgrokImage(
                  imageUrl: images[i],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),
          if (images.length > 1)
            Positioned(
              bottom: 12, left: 0, right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (i) {
                  final on = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: on ? 18 : 8, height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: on ? Colors.white : Colors.white70,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildPriceSection(Product p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rp ${p.price.toStringAsFixed(0)}", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.indigo)),
          const SizedBox(height: 6),
          Text(p.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(p.category.name, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLocation(Product p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 18, color: Colors.grey),
          const SizedBox(width: 6),
          Text(p.location ?? "Lokasi tidak tersedia", style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDetailSpecs(Product p) {
    final specs = <Widget>[];
    final base = {"Kategori": p.category.name, "Tahun": p.year.year, if (p.location != null) "Lokasi": p.location!};
    base.forEach((k, v) => specs.add(_specItem(k, v.toString())));
    p.attributes.forEach((k, v) => specs.add(_specItem(_labelize(k), v.toString())));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Detail", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...specs,
        ],
      ),
    );
  }

  Widget _specItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          Expanded(child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  String _labelize(String key) => key.replaceAll("_", " ").split(" ").map((e) => e.isEmpty ? e : e[0].toUpperCase() + e.substring(1)).join(" ");

  Widget _buildDescription(Product p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Deskripsi", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(p.description, style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
  
  Widget _buildSeller(Product p) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(p.sellerId),
      subtitle: const Text("Penjual"),
    );
  }

  Widget _buildBottomBar(Product p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: ElevatedButton.icon(
        onPressed: () async {
          final authCtrl = Get.find<AuthController>();
          if (authCtrl.currentUser.value == null) {
            Get.toNamed(AppRoutes.login);
            return;
          }
          if (p.sellerId == authCtrl.currentUser.value!.id) {
            Get.snackbar('Info', 'Ini produk Anda sendiri');
            return;
          }
          try {
            final chatCtrl = Get.find<ChatController>();
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
    );
  }
}