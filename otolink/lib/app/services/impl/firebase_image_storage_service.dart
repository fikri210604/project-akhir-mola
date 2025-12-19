import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../image_storage_service.dart';

class FirebaseImageStorageService implements ImageStorageService {
  final FirebaseStorage _storage;
  FirebaseImageStorageService({FirebaseStorage? storage}) : _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<List<String>> uploadProductImages({required String userId, required List<File> files}) async {
    final List<String> urls = [];
    for (var i = 0; i < files.length; i++) {
      final f = files[i];
      final name = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final ref = _storage.ref().child('product_images').child(userId).child(name);
      final task = await ref.putFile(f, SettableMetadata(contentType: 'image/jpeg'));
      final url = await task.ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }
}

