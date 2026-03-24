// lib/models/field_definition.dart

class FieldDefinition {
  final String key;
  final bool isRequired;
  final int order;

  const FieldDefinition({
    required this.key,
    this.isRequired = false,
    required this.order,
  });

  factory FieldDefinition.fromJson(Map<String, dynamic> j) => FieldDefinition(
        key: j['key'] as String,
        isRequired: j['isRequired'] as bool? ?? false,
        order: j['order'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() =>
      {'key': key, 'isRequired': isRequired, 'order': order};

  FieldDefinition copyWith({String? key, bool? isRequired, int? order}) =>
      FieldDefinition(
        key: key ?? this.key,
        isRequired: isRequired ?? this.isRequired,
        order: order ?? this.order,
      );
}
