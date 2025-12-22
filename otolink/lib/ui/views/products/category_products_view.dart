import 'package:flutter/material.dart';
import '../../../app/models/product_category.dart';
import 'product_list_view.dart';

class CategoryProductsView extends StatelessWidget {
  final ProductCategory category;
  const CategoryProductsView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: ProductListView(categoryId: category.id, categoryName: category.name),
      ),
    );
  }
}