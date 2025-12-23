import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/search_controller.dart' as ctrl;
import '../../../app/routes/routes.dart';
import '../../widgets/ngrok_image.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchCtrl = Get.find<ctrl.SearchController>();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: TextField(
          controller: _textController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Cari mobil, motor...",
            border: InputBorder.none,
          ),
          onChanged: (val) {
            _searchCtrl.query.value = val;
            _searchCtrl.search();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () {
              _textController.clear();
              _searchCtrl.query.value = '';
              _searchCtrl.results.clear();
            },
          )
        ],
      ),
      body: Obx(() {
        if (_searchCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_searchCtrl.query.value.isEmpty) {
          return const Center(child: Text("Ketik untuk mencari..."));
        }

        if (_searchCtrl.results.isEmpty) {
          return const Center(child: Text("Tidak ditemukan"));
        }

        return ListView.separated(
          itemCount: _searchCtrl.results.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final p = _searchCtrl.results[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 50, height: 50,
                  child: p.images.isNotEmpty
                      ? NgrokImage(imageUrl: p.images.first, fit: BoxFit.cover)
                      : Container(color: Colors.grey[200]),
                ),
              ),
              title: Text(p.title),
              subtitle: Text("Rp ${p.price.toStringAsFixed(0)}"),
              onTap: () => Get.toNamed(AppRoutes.product, arguments: p.id),
            );
          },
        );
      }),
    );
  }
}