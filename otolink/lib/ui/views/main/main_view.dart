import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_view.dart';
import '../chat/chat_list_view.dart';
import '../products/add_product_view.dart';
import '../favorites/favorite_list_view.dart';
import '../profile/profile_view.dart';
import '../../../app/controllers/favorite_controller.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ChatListView(),
    const SizedBox(), 
    FavoriteListView(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) return; 

    setState(() {
      _currentIndex = index;
    });

    if (index == 3) {
      print("DEBUG_MAIN: Force Loading Favorites...");
      try {
        Get.find<FavoriteController>().loadFavoriteProducts();
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      
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