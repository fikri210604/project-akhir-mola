import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../search/search_view.dart';
import '../products/product_list_view.dart';
import '../products/category_products_view.dart';
import '../../../app/controllers/category_controller.dart';
import '../../../app/controllers/product_controller.dart';
import '../../utils/category_icon_options.dart';
import '../../widgets/ngrok_image.dart';
import '../../../app/routes/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCity = 'Lokasi';
  bool isLoading = false;
  late final CategoryController _categoryCtrl;
  late final ProductController _productCtrl;

  @override
  void initState() {
    super.initState();
    _categoryCtrl = Get.find<CategoryController>();
    _productCtrl = Get.find<ProductController>();
    
    _categoryCtrl.load();
    if (_productCtrl.products.isEmpty) {
      _productCtrl.refreshProducts();
    }
  }

  Future<void> refreshLocation() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      selectedCity = 'Jakarta';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _productCtrl.refreshProducts();
            await _categoryCtrl.load();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),

                _buildSearchBar(),
                const SizedBox(height: 20),

                _buildBannerSection(),
                const SizedBox(height: 20),

                _buildSectionTitle("Kategori"),
                const SizedBox(height: 10),

                _buildCategorySection(),
                const SizedBox(height: 20),

                _buildSectionTitle("Rekomendasi"),
                const SizedBox(height: 10),

                _buildRecommendationCarousel(),
                const SizedBox(height: 20),

                _buildSectionTitle("Produk Terbaru"),
                const SizedBox(height: 10),

                _buildNewestProducts(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              'assets/images/logo.png', 
              width: 40,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.car_repair, size: 40, color: Color(0xFF0A2C6C)),
            ),
          ),

          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
              const SizedBox(width: 4),

              Text(
                selectedCity,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF0A2C6C),
                    ),
                  ),
                ),

              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Color(0xFF0A2C6C),
                  size: 20,
                ),
                tooltip: "Perbarui lokasi",
                onPressed: refreshLocation,
              ),
            ],
          ),

          const Icon(Icons.notifications_none, color: Colors.black54, size: 26),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          Get.to(() => const SearchPage());
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Temukan Mobil, Motor, dll...",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    final banners = [
      'assets/images/banner1.png',
      'assets/images/banner2.png',
      'assets/images/banner3.png', 
    ];

    return SizedBox(
      height: 180,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.9),
          padEnds: false,
          itemCount: banners.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(right: 12, left: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
                image: DecorationImage(
                  image: AssetImage(banners[index]),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
              child: const Center(
                child: Text('Promo Banner', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 10, color: Colors.black)])),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return SizedBox(
      height: 130,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: Obx(() {
          final cats = _categoryCtrl.categories;
          final loading = _categoryCtrl.loading.value;
          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (cats.isEmpty) {
            return const Center(child: Text('Belum ada kategori'));
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cats.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final c = cats[index];
              return GestureDetector(
                onTap: () => Get.to(() => CategoryProductsView(category: c)),
                child: _categoryCard(CategoryIconOptions.iconOf(c.icon), c.name),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _categoryCard(IconData icon, String title) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: const Color(0xFF0A2C6C)),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF0A2C6C),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCarousel() {
    return SizedBox(
      height: 220,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: Obx(() {
          if (_productCtrl.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final allProducts = _productCtrl.products;
          if (allProducts.isEmpty) {
            return const Center(child: Text('Belum ada rekomendasi'));
          }

          final randomList = List.of(allProducts)..shuffle(Random());
          final recommendations = randomList.take(6).toList();

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recommendations.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final p = recommendations[index];
              return GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.product, arguments: p.id),
                child: SizedBox(
                  width: 160,
                  child: _productCard(
                    p.title,
                    "Rp ${p.price.toStringAsFixed(0)}",
                    p.images.isNotEmpty ? p.images.first : '',
                    p.location ?? "Indonesia",
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildNewestProducts() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ProductListView(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0A2C6C),
        ),
      ),
    );
  }

  Widget _productCard(String title, String price, String imageUrl, String location) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageUrl.isNotEmpty
                    ? NgrokImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.grey),
                      )
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            price,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF0A2C6C),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}