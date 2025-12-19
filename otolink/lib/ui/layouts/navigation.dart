import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/home/home_view.dart';
import '../views/profile/profile_view.dart';
import '../views/chat/chat_list_view.dart';
import '../views/products/favorites_view.dart';
import '../views/products/choose_category_view.dart';

class CustomNavigation extends StatefulWidget {
  const CustomNavigation({super.key});

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ChatListView(),
    FavoritesView(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,

      body: IndexedStack(
        index: _currentPageIndex,
        children: _pages,
      ),

      // TOMBOL BULAT TENGAH
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 6,
        shape: const CircleBorder(),
        onPressed: () => Get.to(() => const ChooseCategoryView()),
        child: const Icon(Icons.add, color: Color(0xFF0A2C6C), size: 32),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // NAVIGATION BAR CUSTOM
      bottomNavigationBar: BottomAppBar(
        height: 75,
        color: Colors.white,
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: "Home",
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.chat_outlined,
              activeIcon: Icons.chat,
              label: "Chat",
            ),

            const SizedBox(width: 50), // Space for FAB

            _buildNavItem(
              index: 2,
              icon: Icons.favorite_outline,
              activeIcon: Icons.favorite,
              label: "Favorite",
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: "Akun Saya",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isActive = _currentPageIndex == index;

    return InkWell(
      onTap: () => setState(() => _currentPageIndex = index),
      child: SizedBox(
        width: 70,
        height: 75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? const Color(0xFF0A2C6C) : Colors.grey,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? const Color(0xFF0A2C6C) : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
