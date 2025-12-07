import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/product.dart';
import '../../models/product_category.dart';
import '../../models/brand.dart';
import '../product_service.dart';

class FirebaseProductService implements ProductService {
  final FirebaseFirestore _db;
  FirebaseProductService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('products');

  Product _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    final createdRaw = d['createdAt'];
    final createdAt = createdRaw is Timestamp ? createdRaw.toDate() : DateTime.now();
    final yearRaw = d['year'];
    final DateTime year = yearRaw is int
        ? DateTime(yearRaw, 1, 1)
        : (yearRaw is Timestamp ? yearRaw.toDate() : DateTime(DateTime.now().year));
    final brands = ((d['brands'] as List<dynamic>?) ?? const [])
        .map((e) => e is Map<String, dynamic>
            ? Brand(id: (e['id'] as String?) ?? '', name: (e['name'] as String?) ?? '-')
            : null)
        .whereType<Brand>()
        .toList();
    final attrsRaw = d['attributes'];
    final Map<String, dynamic> attrs = attrsRaw is Map<String, dynamic> ? Map<String, dynamic>.from(attrsRaw) : <String, dynamic>{};
    return Product(
      id: doc.id,
      title: d['title'] as String,
      description: d['description'] as String,
      price: (d['price'] as num).toDouble(),
      category: _categoryFromMap(d['category']),
      brands: brands,
      images: (d['images'] as List<dynamic>? ?? const []).cast<String>(),
      year: year,
      sellerId: d['sellerId'] as String,
      createdAt: createdAt,
      location: d['location'] as String?,
      attributes: attrs,
    );
  }

  ProductCategory _categoryFromMap(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return ProductCategory(
        id: (raw['id'] as String?) ?? '',
        name: (raw['name'] as String?) ?? '-',
        icon: (raw['icon'] as String?) ?? '',
      );
    }
    // Backward compatibility if stored as string name only
    if (raw is String) {
      return ProductCategory(id: raw, name: raw, icon: '');
    }
    return const ProductCategory(id: '', name: '-', icon: '');
  }

  Map<String, dynamic> _toMap(Product p) => {
        'title': p.title,
        'description': p.description,
        'price': p.price,
        'category': {
          'id': p.category.id,
          'name': p.category.name,
          'icon': p.category.icon,
        },
        'brands': p.brands.map((b) => {'id': b.id, 'name': b.name}).toList(),
        'images': p.images,
        'sellerId': p.sellerId,
        'createdAt': FieldValue.serverTimestamp(),
        'location': p.location,
        'year': p.year.year,
        'attributes': p.attributes,
      };

  @override
  Future<Product> addProduct(Product product) async {
    final ref = await _col.add(_toMap(product));
    final doc = await ref.get();
    return _fromDoc(doc);
  }

  @override
  Future<Product?> getProductById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return _fromDoc(doc);
  }

  @override
  Future<List<Product>> listProducts() async {
    final q = await _col.orderBy('createdAt', descending: true).limit(30).get();
    return q.docs.map(_fromDoc).toList();
  }

  @override
  Future<List<Product>> listProductsByCategory(String categoryId) async {
    // Query products where embedded category.id equals the provided id
    final q = await _col.where('category.id', isEqualTo: categoryId).orderBy('createdAt', descending: true).get();
    return q.docs.map(_fromDoc).toList();
  }
}
