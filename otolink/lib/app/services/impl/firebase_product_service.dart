import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product.dart';
import '../../models/product_category.dart';
import '../product_service.dart';

class FirebaseProductService implements ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _products => _db.collection('products');

  Product _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    
    dynamic yearData = d['year'];
    DateTime yearDate;
    if (yearData is int) {
      yearDate = DateTime(yearData);
    } else if (yearData is Timestamp) {
      yearDate = yearData.toDate();
    } else {
      yearDate = DateTime.now();
    }

    return Product(
      id: doc.id,
      title: d['title'] ?? '',
      description: d['description'] ?? '',
      price: (d['price'] as num?)?.toDouble() ?? 0.0,
      category: ProductCategory(
        id: d['category']?['id'] ?? '',
        name: d['category']?['name'] ?? '',
        icon: d['category']?['icon'] ?? '',
      ),
      brands: [], 
      images: List<String>.from(d['images'] ?? []),
      year: yearDate,
      sellerId: d['sellerId'] ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: d['location'],
      attributes: d['attributes'] ?? {},
    );
  }

  @override
  Future<List<Product>> getProducts() async {
    final snap = await _products.orderBy('createdAt', descending: true).get();
    return snap.docs.map(_fromDoc).toList();
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final snap = await _products
        .where('category.id', isEqualTo: categoryId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map(_fromDoc).toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      final doc = await _products.doc(id).get();
      if (doc.exists) {
        return _fromDoc(doc);
      }
    } catch (e) {
      print("Error fetching product by ID: $e");
    }
    return null;
  }

  @override
  Future<void> addProduct(Product product) async {
    await _products.add({
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'category': {
        'id': product.category.id,
        'name': product.category.name,
        'icon': product.category.icon,
      },
      'images': product.images,
      'year': product.year != null ? Timestamp.fromDate(product.year!) : FieldValue.serverTimestamp(),
      'sellerId': product.sellerId,
      'createdAt': FieldValue.serverTimestamp(),
      'location': product.location,
      'attributes': product.attributes,
    });
  }
}