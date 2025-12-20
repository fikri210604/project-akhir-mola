import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../app/models/product.dart';
import '../../../app/models/product_category.dart';
import '../../../app/controllers/product_controller.dart';
import '../../../app/controllers/auth_controller.dart';
import '../../../app/controllers/category_controller.dart';
import '../../utils/category_icon_options.dart';
import '../../../app/services/image_storage_service.dart';

class AddProductView extends StatefulWidget {
  final ProductCategory? initialCategory;
  const AddProductView({super.key, this.initialCategory});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _location = TextEditingController();
  
  ProductCategory? _category;
  bool _submitting = false;
  
  late final CategoryController _categoryCtrl;
  
  final Map<String, TextEditingController> _dynText = {};
  final Map<String, String> _dynSelect = {};
  final Map<String, bool> _dynBool = {};
  
  final List<XFile> _photos = []; 
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _categoryCtrl = Get.find<CategoryController>();
    if (_categoryCtrl.categories.isEmpty) {
      _categoryCtrl.load();
    }
    _category = widget.initialCategory;
    if (_category != null) {
      _categoryCtrl.loadFieldsFor(_category!.id);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _price.dispose();
    _location.dispose();
    for (var c in _dynText.values) c.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final auth = Get.find<AuthController>();
    final user = auth.currentUser.value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final priceVal = double.tryParse(_price.text.replaceAll(',', '.')) ?? 0.0;
      final selected = _category;
      
      if (selected == null) throw 'Pilih kategori terlebih dahulu';

      final attrs = <String, dynamic>{};
      
      for (final f in _categoryCtrl.fields) {
        switch (f.type) {
          case 'text':
          case 'number':
            if (_dynText.containsKey(f.id)) {
              final v = _dynText[f.id]!.text.trim();
              if (f.required && v.isEmpty) throw 'Field "${f.label}" wajib diisi';
              
              if (f.type == 'number' && v.isNotEmpty) {
                final n = num.tryParse(v.replaceAll(',', '.'));
                if (n == null) throw 'Field "${f.label}" harus angka';
                attrs[f.id] = n;
              } else if (v.isNotEmpty) {
                attrs[f.id] = v;
              }
            } else if (f.required) {
               throw 'Field "${f.label}" wajib diisi';
            }
            break;
          case 'select':
            final s = _dynSelect[f.id];
            if (f.required && (s == null || s.isEmpty)) throw 'Pilih ${f.label}';
            if (s != null && s.isNotEmpty) attrs[f.id] = s;
            break;
          case 'bool':
            final b = _dynBool[f.id] ?? false;
            attrs[f.id] = b;
            break;
        }
      }

      List<String> imageUrls = const [];
      if (_photos.isNotEmpty) {
        final storage = Get.find<ImageStorageService>();
        imageUrls = await storage.uploadProductImages(userId: user.id, files: _photos);
      }

      final product = Product(
        id: 'temp',
        title: _title.text.trim(),
        description: _desc.text.trim(),
        price: priceVal,
        category: selected,
        brands: const [],
        images: imageUrls,
        year: DateTime(DateTime.now().year),
        sellerId: user.id,
        createdAt: DateTime.now(),
        location: _location.text.trim().isEmpty ? null : _location.text.trim(),
        attributes: attrs,
      );

      final ctrl = Get.find<ProductController>();
      await ctrl.add(product);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan')),
      );
      Get.back();
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
      appBar: AppBar(title: const Text('Tambah Produk')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Judul'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul wajib' : null,
                ),
                const SizedBox(height: 12),
                Text('Foto Produk', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._photos.asMap().entries.map((e) {
                        final xfile = e.value;
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: kIsWeb
                                  ? Image.network(
                                      xfile.path, 
                                      width: 80, 
                                      height: 80, 
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, o, s) => Container(
                                        width: 80, height: 80, color: Colors.grey, child: const Icon(Icons.error),
                                      ),
                                    )
                                  : Image.file(
                                      File(xfile.path), 
                                      width: 80, 
                                      height: 80, 
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Positioned(
                              right: -8,
                              top: -8,
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                color: Colors.redAccent,
                                onPressed: () => setState(() => _photos.removeAt(e.key)),
                              ),
                            )
                          ],
                        );
                    }),
                    InkWell(
                      onTap: _pickPhotos,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.add_a_photo, color: Color(0xFF0A2C6C)),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _desc,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Deskripsi wajib' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _price,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Harga (Rp)'),
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.isEmpty) return 'Harga wajib';
                    final d = double.tryParse(t.replaceAll(',', '.'));
                    if (d == null || d <= 0) return 'Harga tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Obx(() {
                  final cats = _categoryCtrl.categories;
                  final isLoading = _categoryCtrl.loading.value;
                  final dropdownValue = cats.contains(_category) ? _category : null;

                  return DropdownButtonFormField<ProductCategory>(
                    value: dropdownValue,
                    items: cats
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Row(
                                children: [
                                  Icon(CategoryIconOptions.iconOf(e.icon), size: 18),
                                  const SizedBox(width: 8),
                                  Text(e.name),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _category = v;
                        _dynText.clear();
                        _dynSelect.clear();
                        _dynBool.clear();
                      });
                      _categoryCtrl.loadFieldsFor(v.id);
                    },
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      suffixIcon: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2)),
                            )
                          : null,
                    ),
                    validator: (v) => v == null ? 'Kategori wajib' : null,
                  );
                }),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _location,
                  decoration: const InputDecoration(labelText: 'Lokasi (opsional)'),
                ),
                const SizedBox(height: 16),
                
                Obx(() {
                  final fields = _categoryCtrl.fields;
                  final loading = _categoryCtrl.fieldsLoading.value;
                  if (loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if ((_category?.id ?? '').isEmpty || fields.isEmpty) return const SizedBox.shrink();
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 24),
                      const Text('Detail Kategori', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      ...fields.map((f) {
                        if (f.type == 'text' || f.type == 'number') {
                           if (!_dynText.containsKey(f.id)) {
                             _dynText[f.id] = TextEditingController();
                           }
                        }
                        switch (f.type) {
                          case 'text':
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextFormField(
                                controller: _dynText[f.id],
                                decoration: InputDecoration(labelText: f.label, hintText: f.hint),
                                validator: (v) => (f.required && (v == null || v.trim().isEmpty)) ? '${f.label} wajib' : null,
                              ),
                            );
                          case 'number':
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextFormField(
                                controller: _dynText[f.id],
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(labelText: f.label, hintText: f.hint),
                                validator: (v) {
                                  final t = (v ?? '').trim();
                                  if (f.required && t.isEmpty) return '${f.label} wajib';
                                  if (t.isNotEmpty && num.tryParse(t.replaceAll(',', '.')) == null) return '${f.label} harus angka';
                                  return null;
                                },
                              ),
                            );
                          case 'select':
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: DropdownButtonFormField<String>(
                                value: _dynSelect[f.id],
                                items: (f.options ?? const <String>[])
                                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                                    .toList(),
                                onChanged: (v) => setState(() => _dynSelect[f.id] = v ?? ''),
                                decoration: InputDecoration(labelText: f.label),
                                validator: (v) => (f.required && (v == null || v.isEmpty)) ? '${f.label} wajib' : null,
                              ),
                            );
                          case 'bool':
                            return SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(f.label),
                              subtitle: f.hint != null ? Text(f.hint!) : null,
                              value: _dynBool[f.id] ?? false,
                              onChanged: (v) => setState(() => _dynBool[f.id] = v),
                            );
                          default:
                            return const SizedBox.shrink();
                        }
                      }).toList(),
                    ],
                  );
                }),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitting ? null : _submit,
                    icon: _submitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: Text(_submitting ? 'Memproses...' : 'Lanjut'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickPhotos() async {
    try {
      final files = await _picker.pickMultiImage(imageQuality: 50);
      if (files.isEmpty) return;
      setState(() {
        _photos.addAll(files);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memilih foto: $e')));
    }
  }
}