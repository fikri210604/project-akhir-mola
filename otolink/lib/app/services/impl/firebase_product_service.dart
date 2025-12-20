import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product.dart';
import '../product_service.dart';

class FirebaseProductService implements ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<Product>> listProducts() async {
    final snapshot = await _db.collection('products').orderBy('created_at', descending: true).get();
    return snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList();
  }

  @override
  Future<List<Product>> listProductsByCategory(String categoryId) async {
    final snapshot = await _db
        .collection('products')
        .where('category_id', isEqualTo: categoryId)
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    final doc = await _db.collection('products').doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return Product.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<Product> addProduct(Product product) async {
    final data = product.toMap();
    if (product.id.isEmpty) {
      data.remove('id');
    }
    
    data['created_at'] = FieldValue.serverTimestamp();

    final ref = await _db.collection('products').add(data);
    
    return Product(
      id: ref.id,
      title: product.title,
      description: product.description,
      price: product.price,
      images: product.images,
      category: product.category,
      brand: product.brand,
      year: product.year,
      mileage: product.mileage,
      location: product.location,
      sellerId: product.sellerId,
      sellerName: product.sellerName,
      sellerPhone: product.sellerPhone,
      attributes: product.attributes,
      createdAt: DateTime.now(),
    );
  }
}