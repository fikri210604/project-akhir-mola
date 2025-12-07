import 'dart:io';

abstract class ImageStorageService {
  Future<List<String>> uploadProductImages({required String userId, required List<File> files});
}

