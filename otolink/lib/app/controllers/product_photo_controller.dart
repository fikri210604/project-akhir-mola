import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductPhotoController extends GetxController {
  final mainPhoto = Rx<File?>(null);
  final otherPhotos = <File>[].obs;

  final picker = ImagePicker();

  Future<void> pickMainPhoto() async {
    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x != null) {
      mainPhoto.value = File(x.path);
    }
  }

  Future<void> pickOtherPhoto() async {
    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x != null) {
      otherPhotos.add(File(x.path));
    }
  }

  void removeOtherPhoto(int index) {
    otherPhotos.removeAt(index);
  }
}
