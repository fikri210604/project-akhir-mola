import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../models/product_category.dart';
import '../../models/category_field.dart';
import '../category_service.dart';

class FirebaseCategoryService implements CategoryService {
  final FirebaseFirestore _db;
  FirebaseCategoryService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('categories');

  ProductCategory _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return ProductCategory(
      id: doc.id,
      name: (d['name'] as String?) ?? '-',
      icon: (d['icon'] as String?) ?? '',
    );
  }

  Map<String, dynamic> _toMap({required String name, required String icon}) => {
        'name': name,
        'icon': icon,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

  @override
  Future<ProductCategory> createCategory({required String name, required String icon}) async {
    final ref = await _col.add(_toMap(name: name, icon: icon));
    final snap = await ref.get();
    return _fromDoc(snap);
  }

  @override
  Future<List<ProductCategory>> listCategories() async {
    final q = await _col.orderBy('name').get();
    return q.docs.map(_fromDoc).toList();
  }

  CategoryField _fieldFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return CategoryField(
      id: doc.id,
      label: (d['label'] as String?) ?? 'Field',
      type: (d['type'] as String?) ?? 'text',
      required: (d['required'] as bool?) ?? false,
      order: (d['order'] as num?)?.toInt() ?? 0,
      hint: d['hint'] as String?,
      options: (d['options'] as List<dynamic>?)?.cast<String>(),
      unit: d['unit'] as String?,
      min: d['min'] as num?,
      max: d['max'] as num?,
    );
  }

  @override
  Future<List<CategoryField>> listFields(String categoryId) async {
    try {
      final q = await _col.doc(categoryId).collection('fields').orderBy('order').get();
      if (q.docs.isNotEmpty) {
        return q.docs.map(_fieldFromDoc).toList();
      }
    } catch (e) {
      debugPrint("Error loading fields (ordered): $e");
    }
    
    try {
      final qFallback = await _col.doc(categoryId).collection('fields').get();
      return qFallback.docs.map(_fieldFromDoc).toList();
    } catch (e) {
      debugPrint("Error loading fields (fallback): $e");
      return [];
    }
  }
}