import 'package:image_picker/image_picker.dart';

abstract class ImageStorageService {
  Future<List<String>> uploadProductImages({required String userId, required List<XFile> files});
  Future<String> uploadImage(XFile file, String folderName);
}