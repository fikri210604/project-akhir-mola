import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';
import '../image_storage_service.dart';

class HttpImageStorageService implements ImageStorageService {
  
  @override
  Future<List<String>> uploadProductImages({required String userId, required List<XFile> files}) async {
    final futures = files.map((file) => uploadImage(file, 'products/$userId'));
    final results = await Future.wait(futures);
    return results.where((url) => url.isNotEmpty).toList();
  }

  @override
  Future<String> uploadImage(XFile file, String folderName) async {
    try {
      final uri = Uri.parse('${AppConstants.storageBaseUrl}/upload');
      var request = http.MultipartRequest('POST', uri);
      
      request.headers.addAll({
        'ngrok-skip-browser-warning': 'true',
        'Access-Control-Allow-Origin': '*',
      });

      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: file.name,
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }
      
      var response = await request.send();
      
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);
        
        final serverUrl = json['url'] as String;
        final filename = serverUrl.split('/').last;
        
        return '${AppConstants.storageBaseUrl}/images/$filename';
      }
    } catch (e) {
      return '';
    }
    return '';
  }
}