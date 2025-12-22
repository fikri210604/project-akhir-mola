import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/product_photo_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/favorite_controller.dart';

import '../services/impl/firebase_auth_service.dart';
import '../services/impl/firebase_chat_service.dart';
import '../services/impl/firebase_product_service.dart';
import '../services/impl/firebase_category_service.dart';
import '../services/impl/firebase_favorite_service.dart';
import '../services/impl/http_image_storage_service.dart'; 

import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/product_service.dart';
import '../services/category_service.dart';
import '../services/image_storage_service.dart';
import '../services/favorite_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(FirebaseAuthService(), permanent: true);
    Get.put<ProductService>(FirebaseProductService(), permanent: true);
    Get.put<ChatService>(FirebaseChatService(), permanent: true);
    Get.put<CategoryService>(FirebaseCategoryService(), permanent: true);
    Get.put<ImageStorageService>(HttpImageStorageService(), permanent: true);
    Get.put<FavoriteService>(FirebaseFavoriteService(), permanent: true);

    Get.put(AuthController(Get.find<AuthService>()), permanent: true);
    
    Get.put(ProductController(Get.find<ProductService>()), permanent: true);
    Get.put(ChatController(Get.find<ChatService>(), Get.find<AuthService>()), permanent: true);
    Get.put(ProfileController(Get.find<AuthService>()), permanent: true);
    Get.put(CategoryController(Get.find<CategoryService>()), permanent: true);
    Get.put(ProductPhotoController(Get.find<ImageStorageService>()));
    
    Get.put(FavoriteController(
      Get.find<FavoriteService>(), 
      Get.find<AuthController>(),
      Get.find<ProductService>(),
    ), permanent: true);
  }
}