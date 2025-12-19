import 'dart:math';

import '../../models/product.dart';
import '../../models/product_category.dart';
import '../../models/brand.dart';
import '../product_service.dart';

class MemoryProductService implements ProductService {
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Laptop Ultrabook',
      description: 'Intel i5, 16GB RAM, 512GB SSD',
      price: 9500000,
      category: ProductCategory(id: 'electronics', name: 'Elektronik', icon: 'device_laptop'),
      brands: const [Brand(id: 'asus', name: 'Asus')],
      images: const [],
      year: DateTime(2022, 1, 1),
      sellerId: 's1',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      location: 'Jakarta',
      attributes: const {'processor': 'Intel i5', 'ram_gb': 16},
    ),
    Product(
      id: 'p2',
      title: 'Motor Bekas 2018',
      description: 'Kondisi bagus, pajak hidup',
      price: 10500000,
      category: ProductCategory(id: 'vehicle', name: 'Kendaraan', icon: 'car'),
      brands: const [Brand(id: 'honda', name: 'Honda')],
      images: const [],
      year: DateTime(2018, 1, 1),
      sellerId: 's2',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      location: 'Bandung',
      attributes: const {'kilometers': 25000, 'transmission': 'AT'},
    ),
  ];

  @override
  Future<Product> addProduct(Product product) async {
    final id = 'p_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
    final created = Product(
      id: id,
      title: product.title,
      description: product.description,
      price: product.price,
      category: product.category,
      brands: product.brands,
      images: product.images,
      year: product.year,
      sellerId: product.sellerId,
      createdAt: DateTime.now(),
      location: product.location,
      attributes: Map<String, dynamic>.from(product.attributes),
    );
    _items.insert(0, created);
    return created;
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Product>> listProducts() async {
    return List<Product>.unmodifiable(_items);
  }

  @override
  Future<List<Product>> listProductsByCategory(String categoryId) async {
    return _items.where((e) => e.category.id == categoryId).toList(growable: false);
  }
}
