import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_storage_service.dart';
import '../controllers/auth_controller.dart';

class ProductPhotoController extends GetxController {
  final ImageStorageService _storageService;
  
  ProductPhotoController(this._storageService);

  final RxList<String> imageUrls = <String>[].obs;
  final RxBool uploading = false.obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUpload() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await uploadPhoto(image);
    }
  }

  Future<void> uploadPhoto(XFile file) async {
    uploading.value = true;
    try {
      final authCtrl = Get.find<AuthController>();
      final user = authCtrl.currentUser.value;
      
      if (user == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final url = await _storageService.uploadImage(file, 'products/${user.id}');
      imageUrls.add(url);
    } catch (e) {
      Get.snackbar("Error", "Upload failed: $e");
    } finally {
      uploading.value = false;
    }
  }

  void removePhoto(int index) {
    imageUrls.removeAt(index);
  }
  
  void clear() {
    imageUrls.clear();
  }
}