import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/product_controller.dart';
import '../../../app/models/product.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class EditProductView extends StatefulWidget {
  const EditProductView({super.key});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final Product product = Get.arguments;
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _locCtrl;
  late TextEditingController _yearCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: product.title);
    _descCtrl = TextEditingController(text: product.description);
    _priceCtrl = TextEditingController(text: product.price.toStringAsFixed(0));
    _locCtrl = TextEditingController(text: product.location ?? '');
    _yearCtrl = TextEditingController(text: product.year.year.toString());
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _locCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productCtrl = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Produk"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Informasi Dasar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              AppTextField(
                controller: _titleCtrl,
                label: "Judul Iklan",
                hint: "Contoh: Toyota Avanza 2020",
                validator: (v) => v!.isEmpty ? "Judul wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _priceCtrl,
                label: "Harga (Rp)",
                hint: "0",
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Harga wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _yearCtrl,
                      label: "Tahun",
                      hint: "2023",
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? "Tahun wajib diisi" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextField(
                      controller: _locCtrl,
                      label: "Lokasi",
                      hint: "Jakarta Selatan",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Deskripsi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              AppTextField(
                controller: _descCtrl,
                label: "Jelaskan produk anda",
                hint: "Tulis deskripsi lengkap...",
                maxLines: 5,
                validator: (v) => v!.isEmpty ? "Deskripsi wajib diisi" : null,
              ),
              const SizedBox(height: 32),
              Obx(() => AppButton.primary( // PERBAIKAN: Menggunakan .primary
                label: "Simpan Perubahan",
                loading: productCtrl.loading.value,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final newPrice = double.tryParse(_priceCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                      final newYear = int.tryParse(_yearCtrl.text) ?? DateTime.now().year;

                      final updatedProduct = Product(
                        id: product.id,
                        title: _titleCtrl.text,
                        description: _descCtrl.text,
                        price: newPrice,
                        category: product.category,
                        brands: product.brands,
                        images: product.images,
                        year: DateTime(newYear),
                        sellerId: product.sellerId,
                        createdAt: product.createdAt,
                        location: _locCtrl.text,
                        attributes: product.attributes,
                        status: product.status,
                      );

                      await productCtrl.edit(updatedProduct);
                      Get.back();
                      Get.snackbar("Sukses", "Produk berhasil diperbarui", backgroundColor: Colors.green, colorText: Colors.white);
                    } catch (e) {
                      Get.snackbar("Error", "Gagal memperbarui produk", backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}