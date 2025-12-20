import 'product_category.dart';
import 'brand.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final ProductCategory category;
  final List<Brand> brands;
  final List<String> images;
  final DateTime year;
  final String sellerId;
  final DateTime createdAt;
  final String? location;

  final Map<String, dynamic> attributes;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.brands,
    required this.images,
    required this.year,
    required this.sellerId,
    required this.createdAt,
    this.attributes = const {},
    this.location,
  });
}