import 'package:get/get.dart';
import '../../ui/views/auth/login_view.dart';
import '../../ui/views/auth/phone_login_view.dart';
import '../../ui/views/auth/signup_flow_view.dart';
import '../../ui/views/home/welcome_page.dart';
import '../../ui/views/products/product_detail_view.dart';
import '../../ui/views/products/edit_product_view.dart'; 
import '../../ui/views/chat/chat_room_view.dart';
import '../../ui/views/favorites/favorite_list_view.dart';
import '../../ui/views/main/main_view.dart';
import '../../ui/views/settings/settings_view.dart';
import '../../ui/views/help/help_view.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String loginPhone = '/login_phone';
  static const String main = '/main';
  static const String product = '/product';
  static const String editProduct = '/edit-product';
  static const String chatRoom = '/chat_room';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  static const String help = '/help';

  static final List<GetPage<dynamic>> pages = [
    GetPage(name: welcome, page: () => const WelcomePage()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: loginPhone, page: () => const PhoneLoginPage()),
    GetPage(name: signup, page: () => const SignupFlowPage()),
    GetPage(name: main, page: () => const MainView()),
    GetPage(name: product, page: () => const ProductDetailView()),
    GetPage(name: editProduct, page: () => const EditProductView()),
    GetPage(name: chatRoom, page: () => const ChatRoomView()),
    GetPage(name: favorites, page: () => const FavoriteListView()),
    GetPage(name: settings, page: () => const SettingsView()),
    GetPage(name: help, page: () => const HelpView()),
  ];
}