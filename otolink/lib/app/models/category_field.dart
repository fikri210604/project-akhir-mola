class CategoryField {
  final String id;
  final String label;
  final String type;
  final bool required;
  final int order;
  final String? hint;
  final List<String>? options;
  final String? unit;
  final num? min;
  final num? max;

  const CategoryField({
    required this.id,
    required this.label,
    required this.type,
    this.required = false,
    this.order = 0,
    this.hint,
    this.options,
    this.unit,
    this.min,
    this.max,
  });
}