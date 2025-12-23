import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/home/home_view.dart';
import '../views/chat/chat_list_view.dart';
import '../views/products/add_product_view.dart';
import '../views/favorites/favorite_list_view.dart';
import '../views/profile/profile_view.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) return; 

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBody;
    switch (_currentIndex) {
      case 0:
        currentBody = const HomePage();
        break;
      case 1:
        currentBody = const ChatListView();
        break;
      case 3:
        currentBody = FavoriteListView(key: UniqueKey());
        break;
      case 4:
        currentBody = const ProfileView();
        break;
      default:
        currentBody = const HomePage();
    }

    return Scaffold(
      body: currentBody,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddProductView()),
        backgroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Color(0xFF0A2C6C), size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(0, Icons.home_outlined, Icons.home, "Home"),
              _buildTabItem(1, Icons.chat_bubble_outline, Icons.chat_bubble, "Chat"),
              const SizedBox(width: 48), 
              _buildTabItem(3, Icons.favorite_border, Icons.favorite, "Favorite"),
              _buildTabItem(4, Icons.person_outline, Icons.person, "Akun Saya"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, IconData activeIcon, String label) {
    final bool isActive = _currentIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            color: isActive ? const Color(0xFF0A2C6C) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? const Color(0xFF0A2C6C) : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}