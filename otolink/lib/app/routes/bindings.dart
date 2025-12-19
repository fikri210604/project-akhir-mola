import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/profile_controller.dart';
import '../services/impl/firebase_auth_service.dart';
import '../services/impl/firebase_chat_service.dart';
import '../services/impl/firebase_product_service.dart';
import '../services/impl/firebase_image_storage_service.dart';
import '../services/impl/firebase_category_service.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/product_service.dart';
import '../services/category_service.dart';
import '../services/image_storage_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<AuthService>(FirebaseAuthService(), permanent: true);
    Get.put<ProductService>(FirebaseProductService(), permanent: true);
    Get.put<ChatService>(FirebaseChatService(), permanent: true);
    Get.put<CategoryService>(FirebaseCategoryService(), permanent: true);
    Get.put<ImageStorageService>(FirebaseImageStorageService(), permanent: true);

    // Controllers
    Get.put(AuthController(Get.find<AuthService>()), permanent: true);
    Get.put(ProductController(Get.find<ProductService>()), permanent: true);
    Get.put(ChatController(Get.find<ChatService>()), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(CategoryController(Get.find<CategoryService>()), permanent: true);
  }
}
