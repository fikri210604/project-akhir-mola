class ProductCategory {
  final String id;
  final String name;
  final String icon;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}