import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../app/controllers/category_controller.dart';
import '../../../app/controllers/product_controller.dart';
import '../../../app/controllers/product_photo_controller.dart';
import '../../../app/services/auth_service.dart';
import '../../../app/models/product.dart';
import '../../../app/models/product_category.dart';
import '../../widgets/input_text_view.dart';
import '../../widgets/app_button.dart';

class AddProductView extends StatefulWidget {
  final ProductCategory? initialCategory;
  const AddProductView({super.key, this.initialCategory});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  late final ProductController _productCtrl;
  late final CategoryController _categoryCtrl;
  late final ProductPhotoController _photoCtrl;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _brandController = TextEditingController();
  final _yearController = TextEditingController();
  final _mileageController = TextEditingController();
  final _locationController = TextEditingController();

  ProductCategory? _selectedCategory;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _productCtrl = Get.find<ProductController>();
    _categoryCtrl = Get.find<CategoryController>();
    _photoCtrl = Get.find<ProductPhotoController>();
    
    _photoCtrl.clear();
    _selectedCategory = widget.initialCategory;
    
    if (_categoryCtrl.categories.isEmpty) {
      _categoryCtrl.load();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _brandController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _brandController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul, Harga, Merek, dan Kategori wajib diisi')),
      );
      return;
    }

    if (_photoCtrl.selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal upload 1 foto')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final imageUrls = await _photoCtrl.uploadAll();
      final user = Get.find<AuthService>().currentUser;
      
      if (user == null) throw Exception("Sesi habis, silakan login ulang");

      final product = Product(
        id: '',
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        price: double.tryParse(_priceController.text.replaceAll('.', '')) ?? 0,
        images: imageUrls,
        category: _selectedCategory!,
        brand: _brandController.text.trim(),
        year: DateTime(int.tryParse(_yearController.text) ?? DateTime.now().year),
        mileage: int.tryParse(_mileageController.text) ?? 0,
        location: _locationController.text.trim(),
        sellerId: user.id,
        sellerName: user.displayName,
        sellerPhone: '',
        attributes: {},
        createdAt: DateTime.now(),
      );

      await _productCtrl.add(product);

      if (!mounted) return;
      Get.back();
      if (widget.initialCategory != null) Get.back(); 
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jual Barang')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPhotoSection(),
            const SizedBox(height: 20),
            const Text("Informasi Utama", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            AppTextField(
              controller: _titleController,
              label: 'Judul Iklan',
              hint: 'Contoh: Honda Jazz RS 2018',
            ),
            const SizedBox(height: 12),
            _buildCategoryDropdown(),
            const SizedBox(height: 12),
            AppTextField(
              controller: _brandController,
              label: 'Merek / Brand',
              hint: 'Contoh: Honda, Yamaha, Apple',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _priceController,
                    label: 'Harga (Rp)',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    controller: _yearController,
                    label: 'Tahun',
                    hint: 'YYYY',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _mileageController,
                    label: 'Kilometer (Opsional)',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    controller: _locationController,
                    label: 'Lokasi',
                    hint: 'Kota, Kecamatan',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _descController,
              label: 'Deskripsi Lengkap',
              hint: 'Jelaskan kondisi barang',
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 30),
            AppButton.primary(
              label: _submitting ? 'Mengirim...' : 'Tayangkan Iklan',
              onPressed: _submitting ? null : _submit,
              loading: _submitting,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Foto Produk", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Obx(() {
          final files = _photoCtrl.selectedFiles;
          return SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: files.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: _photoCtrl.pickImages,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_a_photo, color: Colors.grey),
                    ),
                  );
                }
                final file = files[index - 1];
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(file.path), width: 100, height: 100, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _photoCtrl.removeImage(index - 1),
                        child: Container(
                          color: Colors.black54,
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Kategori", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF0A2C6C))),
        const SizedBox(height: 6),
        Obx(() {
          if (_categoryCtrl.loading.value) {
            return const LinearProgressIndicator();
          }
          final cats = _categoryCtrl.categories;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ProductCategory>(
                isExpanded: true,
                hint: const Text("Pilih Kategori"),
                value: _selectedCategory,
                items: cats.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(c.name),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => _selectedCategory = val);
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}