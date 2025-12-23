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
    if (id is! String) return Scaffold(body: Center(child: Text('not_found'.tr)));

    final ctrl = Get.find<ProductController>();
    final theme = Theme.of(context);

    return FutureBuilder<Product?>(
      future: ctrl.byId(id),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final p = snap.data;
        if (p == null) return Scaffold(body: Center(child: Text('not_found'.tr)));

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text('detail_product'.tr),
            centerTitle: true,
            elevation: 0.3,
            backgroundColor: theme.appBarTheme.backgroundColor,
            foregroundColor: theme.appBarTheme.foregroundColor,
            actions: [
              IconButton(icon: const Icon(Icons.share), onPressed: () {}),
              
              GetBuilder<FavoriteController>(
                init: Get.isRegistered<FavoriteController>() ? Get.find<FavoriteController>() : null,
                builder: (favCtrl) {
                  final isFav = favCtrl.isFav(p.id);
                  return GestureDetector(
                    onTap: () async {
                      await _favAnimCtrl.forward().then((_) => _favAnimCtrl.reverse());
                      favCtrl.toggleFavorite(p);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ScaleTransition(
                        scale: _favScaleAnim.drive(Tween(begin: 1.0, end: 1.5)),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.pink : theme.iconTheme.color,
                          size: 26,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarousel(p.images, p.status),
                const SizedBox(height: 20),
                _buildPriceSection(p, theme),
                const Divider(height: 32),
                _buildLocation(p, theme),
                const Divider(height: 32),
                _buildDetailSpecs(p, theme),
                const Divider(height: 32),
                _buildDescription(p, theme),
                const Divider(height: 32),
                _buildSeller(p, theme),
                const SizedBox(height: 20),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(p, theme),
        );
      },
    );
  }

  Widget _buildCarousel(List<String> images, ProductStatus status) {
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
          if (status == ProductStatus.sold)
            Container(
              color: Colors.black54,
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: -0.5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'sold'.tr,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
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

  Widget _buildPriceSection(Product p, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rp ${p.price.toStringAsFixed(0)}", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
          const SizedBox(height: 6),
          Text(p.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 4),
          Text(p.category.name, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLocation(Product p, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 18, color: Colors.grey),
          const SizedBox(width: 6),
          Text(p.location ?? 'location_na'.tr, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDetailSpecs(Product p, ThemeData theme) {
    final specs = <Widget>[];
    final base = {'categories'.tr: p.category.name, 'year'.tr: p.year.year, if (p.location != null) 'location'.tr: p.location!};
    base.forEach((k, v) => specs.add(_specItem(k, v.toString(), theme)));
    p.attributes.forEach((k, v) => specs.add(_specItem(_labelize(k), v.toString(), theme)));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('detail'.tr, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 10),
          ...specs,
        ],
      ),
    );
  }

  Widget _specItem(String title, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          Expanded(child: Text(value, textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface))),
        ],
      ),
    );
  }

  String _labelize(String key) => key.replaceAll("_", " ").split(" ").map((e) => e.isEmpty ? e : e[0].toUpperCase() + e.substring(1)).join(" ");

  Widget _buildDescription(Product p, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('description'.tr, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 10),
          Text(p.description, style: TextStyle(fontSize: 14, height: 1.5, color: theme.colorScheme.onSurface.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
  
  Widget _buildSeller(Product p, ThemeData theme) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(Icons.person, color: theme.colorScheme.onPrimaryContainer),
      ),
      title: Text(p.sellerId, style: TextStyle(color: theme.colorScheme.onSurface)),
      subtitle: Text('seller'.tr, style: const TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildBottomBar(Product p, ThemeData theme) {
    final isSold = p.status == ProductStatus.sold;
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0 : 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: ElevatedButton.icon(
        onPressed: isSold ? null : () async {
          final authCtrl = Get.find<AuthController>();
          if (authCtrl.currentUser.value == null) {
            Get.toNamed(AppRoutes.login);
            return;
          }
          if (p.sellerId == authCtrl.currentUser.value!.id) {
            Get.snackbar('Info', 'own_product'.tr);
            return;
          }
          try {
            final chatCtrl = Get.find<ChatController>();
            final thread = await chatCtrl.createThread(p.sellerId);
            
            chatCtrl.initChat(thread.id);
            await chatCtrl.sendMessage(
              customText: "Halo, saya tertarik dengan ${p.title} seharga Rp ${p.price.toStringAsFixed(0)}."
            );

            Get.toNamed(AppRoutes.chatRoom, arguments: thread.id);
          } catch (e) {
            Get.snackbar('Error', 'Gagal memulai chat: $e');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSold ? Colors.grey : theme.colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        icon: const Icon(Icons.chat),
        label: Text(isSold ? 'product_sold'.tr : 'chat_seller'.tr),
      ),
    );
  }
}