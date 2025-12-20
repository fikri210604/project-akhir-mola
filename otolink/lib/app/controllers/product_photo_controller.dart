import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_storage_service.dart';
import '../services/auth_service.dart';

class ProductPhotoController extends GetxController {
  final ImageStorageService _service;
  ProductPhotoController(this._service);

  final selectedFiles = <XFile>[].obs;
  final picker = ImagePicker();

  Future<void> pickImages() async {
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedFiles.addAll(images);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
    }
  }

  void clear() {
    selectedFiles.clear();
  }

  Future<List<String>> uploadAll() async {
    try {
      final authService = Get.find<AuthService>();
      final userId = authService.currentUser?.id;
      if (userId == null) return [];
      
      return await _service.uploadProductImages(userId: userId, files: selectedFiles);
    } catch (e) {
      return [];
    }
  }
}