import 'dart:io';

abstract class ImageStorageService {
  Future<String> uploadImage(File file, String folderName);
  Future<List<String>> uploadProductImages({required String userId, required List<File> files});
}