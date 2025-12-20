import 'dart:convert';
import 'dart:io';
import '../image_storage_service.dart';

class FirebaseImageStorageService implements ImageStorageService {
  @override
  Future<String> uploadImage(File file, String folderName) async {
    final bytes = await file.readAsBytes();
    final base64String = base64Encode(bytes);
    return base64String;
  }

  @override
  Future<List<String>> uploadProductImages({required String userId, required List<File> files}) async {
    List<String> results = [];
    for (var file in files) {
      final str = await uploadImage(file, 'products');
      results.add(str);
    }
    return results;
  }
}