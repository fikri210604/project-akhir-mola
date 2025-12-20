import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_category.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final ProductCategory category;
  final String brand; 
  final DateTime year;
  final int mileage;
  final String? location;
  final String sellerId;
  final String sellerName;
  final String sellerPhone;
  final Map<String, dynamic> attributes;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.brand,
    required this.year,
    required this.mileage,
    this.location,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhone,
    required this.attributes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'images': images,
      'category_id': category.id,
      'category_name': category.name,
      'category_icon': category.icon,
      'brand': brand,
      'year': Timestamp.fromDate(year),
      'mileage': mileage,
      'location': location,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'seller_phone': sellerPhone,
      'attributes': attributes,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      images: List<String>.from(map['images'] ?? []),
      category: ProductCategory(
        id: map['category_id'] ?? 'unknown',
        name: map['category_name'] ?? 'Lainnya',
        icon: map['category_icon'] ?? 'category',
      ),
      brand: map['brand'] ?? '',
      year: (map['year'] as Timestamp?)?.toDate() ?? DateTime.now(),
      mileage: map['mileage'] ?? 0,
      location: map['location'],
      sellerId: map['seller_id'] ?? '',
      sellerName: map['seller_name'] ?? '',
      sellerPhone: map['seller_phone'] ?? '',
      attributes: Map<String, dynamic>.from(map['attributes'] ?? {}),
      createdAt: (map['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}