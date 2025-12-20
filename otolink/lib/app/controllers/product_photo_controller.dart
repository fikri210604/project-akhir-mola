import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_storage_service.dart';

class ProductPhotoController extends GetxController {
  final ImageStorageService _service;
  ProductPhotoController(this._service);

  final RxList<File> selectedFiles = <File>[].obs;
  final RxList<String> uploadedUrls = <String>[].obs;
  final RxBool uploading = false.obs;

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final results = await picker.pickMultiImage(imageQuality: 50); // Kompres agar string base64 tidak terlalu besar
    if (results.isNotEmpty) {
      selectedFiles.addAll(results.map((e) => File(e.path)));
    }
  }

  void removeImage(int index) {
    selectedFiles.removeAt(index);
  }

  Future<List<String>> uploadAll() async {
    if (selectedFiles.isEmpty) return [];

    uploading.value = true;
    uploadedUrls.clear();

    try {
      for (final file in selectedFiles) {
        final result = await _service.uploadImage(file, 'products');
        uploadedUrls.add(result);
      }
      return uploadedUrls;
    } catch (e) {
      rethrow;
    } finally {
      uploading.value = false;
    }
  }

  void clear() {
    selectedFiles.clear();
    uploadedUrls.clear();
  }
}