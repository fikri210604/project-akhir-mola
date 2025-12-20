import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/product_controller.dart';
import '../../../app/models/product.dart';
import '../../widgets/smart_image.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments;

    if (id is! String) {
      return const Scaffold(
        body: Center(child: Text("Produk tidak ditemukan")),
      );
    }

    final ctrl = Get.find<ProductController>();

    return FutureBuilder<Product?>(
      future: ctrl.byId(id),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final p = snap.data;
        if (p == null) {
          return const Scaffold(
            body: Center(child: Text("Produk tidak ditemukan")),
          );
        }

        return _buildDetail(p);
      },
    );
  }

  Widget _buildDetail(Product p) {
    final images = p.images;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail Produk"),
        centerTitle: true,
        elevation: 0.3,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarousel(images),
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
    );
  }

  Widget _buildCarousel(List<String> images) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Stack(
        children: [
          PageView.builder(
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
              return SmartImage(
                images[i],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
          if (images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (i) {
                  final on = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: on ? 18 : 8,
                    height: 8,
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
          Text(
            "Rp ${p.price.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            p.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            p.category.name,
            style: const TextStyle(color: Colors.grey),
          ),
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
          Text(
            p.location ?? "Lokasi tidak tersedia",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSpecs(Product p) {
    final specs = <Widget>[];

    final base = {
      "Kategori": p.category.name,
      "Tahun": p.year.year,
      if (p.location != null) "Lokasi": p.location!,
    };

    base.forEach((k, v) => specs.add(_specItem(k, v.toString())));

    p.attributes.forEach((k, v) {
      specs.add(_specItem(_labelize(k), v.toString()));
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detail",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  String _labelize(String key) {
    return key
        .replaceAll("_", " ")
        .split(" ")
        .map((e) => e.isEmpty ? e : e[0].toUpperCase() + e.substring(1))
        .join(" ");
  }

  Widget _buildDescription(Product p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Deskripsi",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            p.description,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
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
}