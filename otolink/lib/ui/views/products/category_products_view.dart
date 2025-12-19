import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/models/product_category.dart';
import 'product_list_view.dart';
import '../../utils/category_icon_options.dart';

class CategoryProductsView extends StatelessWidget {
  final ProductCategory category;
  const CategoryProductsView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(CategoryIconOptions.iconOf(category.icon)),
            const SizedBox(width: 8),
            Text(category.name),
          ],
        ),
      ),
      body: SafeArea(
        child: ProductListView(categoryId: category.id, categoryName: category.name),
      ),
    );
  }
}

