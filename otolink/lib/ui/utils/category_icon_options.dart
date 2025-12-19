import 'package:flutter/cupertino.dart';

class CategoryIconOptions {
  static const Map<String, IconData> map = {
    'car': CupertinoIcons.car,
    'phone': CupertinoIcons.phone,
    'device_laptop': CupertinoIcons.device_laptop,
    'cart': CupertinoIcons.cart,
    'tag': CupertinoIcons.tag,
    'house': CupertinoIcons.house,
    'camera': CupertinoIcons.camera,
  };

  static const List<String> keys = [
    'car',
    'phone',
    'device_laptop',
    'cart',
    'tag',
    'house',
    'camera',
  ];

  static IconData iconOf(String? key) => map[key] ?? CupertinoIcons.tag;
}

