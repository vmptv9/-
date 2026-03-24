// lib/models/item_model.dart

class MaterialItem {
  final String id;
  final String categoryId;
  final String name;
  final String brand;
  final Map<String, String> specs;
  final DateTime createdAt;

  const MaterialItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.brand,
    required this.specs,
    required this.createdAt,
  });

  factory MaterialItem.fromJson(Map<String, dynamic> j) => MaterialItem(
        id: j['id'] as String,
        categoryId: j['categoryId'] as String,
        name: j['name'] as String,
        brand: j['brand'] as String,
        specs: Map<String, String>.from(j['specs'] as Map),
        createdAt: DateTime.parse(j['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'name': name,
        'brand': brand,
        'specs': specs,
        'createdAt': createdAt.toIso8601String(),
      };

  MaterialItem copyWith({
    String? id,
    String? categoryId,
    String? name,
    String? brand,
    Map<String, String>? specs,
    DateTime? createdAt,
  }) =>
      MaterialItem(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        brand: brand ?? this.brand,
        specs: specs ?? this.specs,
        createdAt: createdAt ?? this.createdAt,
      );

  static String generateId() =>
      DateTime.now().millisecondsSinceEpoch.toString();
}
