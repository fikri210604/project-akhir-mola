import 'package:flutter/material.dart';
import '../products/product_list_view.dart';
import 'package:get/get.dart';
import '../search/search_view.dart';
import '../../../app/controllers/category_controller.dart';
import '../../utils/category_icon_options.dart';
import '../products/category_products_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCity = 'Lokasi';
  bool isLoading = false;
  late final CategoryController _categoryCtrl;

  @override
  void initState() {
    super.initState();
    _categoryCtrl = Get.find<CategoryController>();
    _categoryCtrl.load();
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

              _buildRecommendation(),
              const SizedBox(height: 20),

              _buildSectionTitle("Produk Terbaru"),
              const SizedBox(height: 10),

              _buildNewestProducts(),
            ],
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
            child: Image.asset('assets/images/logo.png', width: 40),
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
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 10),
              Text(
                "Temukan Mobil, Motor, Sepeda, dan lain-lainnya...",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _bannerCard('assets/images/banner1.png'),
          _bannerCard('assets/images/banner2.png'),
        ],
      ),
    );
  }

  Widget _bannerCard(String imagePath) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildCategorySection() {
    return SizedBox(
      height: 130,
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

  Widget _buildRecommendation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _productCard(
              "Honda CIVIC 1.5L 2020",
              "Rp 530.000.000",
              "assets/images/mobil1.png",
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _productCard(
              "Koenigsegg Agera RS 2020",
              "Rp 1.350.000.000",
              "assets/images/mobil2.png",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewestProducts() {
    return const SizedBox(
      height: 400,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ProductListView(),
      ),
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

  Widget _productCard(String title, String price, String imagePath) {
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
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            price,
            style: const TextStyle(
              color: Color(0xFF0A2C6C),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 3),
          const Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey, size: 14),
              SizedBox(width: 4),
              Text("Rajabasa, Bandar L", style: TextStyle(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}