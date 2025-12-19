import 'package:get/get.dart';
import '../../ui/views/auth/login_view.dart';
import '../../ui/views/auth/phone_login_view.dart';
import '../../ui/views/auth/signup_flow_view.dart';
import '../../ui/views/home/welcome_page.dart';
import '../../ui/views/products/product_detail_view.dart';
import '../../ui/views/chat/chat_room_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String loginPhone = '/login_phone';
  static const String product = '/product';
  static const String chat = '/chat';
  static const String welcome = '/welcome';

  static final List<GetPage<dynamic>> pages = [
    GetPage(name: welcome, page: () => const WelcomePage()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: loginPhone, page: () => const PhoneLoginPage()),
    GetPage(name: signup, page: () => const SignupFlowPage()),
    GetPage(name: product, page: () => const ProductDetailView()),
    GetPage(name: chat, page: () => const ChatRoomView()),
  ];
}