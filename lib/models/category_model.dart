// lib/models/category_model.dart
import 'package:flutter/material.dart';
import 'field_definition.dart';

class CategoryModel {
  final String id;
  final String label;
  final String icon;
  final int colorValue;
  final List<FieldDefinition> fields;

  const CategoryModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.colorValue,
    required this.fields,
  });

  Color get color => Color(colorValue);

  factory CategoryModel.fromJson(Map<String, dynamic> j) => CategoryModel(
        id: j['id'] as String,
        label: j['label'] as String,
        icon: j['icon'] as String,
        colorValue: j['colorValue'] as int,
        fields: (j['fields'] as List<dynamic>)
            .map((f) => FieldDefinition.fromJson(f as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'icon': icon,
        'colorValue': colorValue,
        'fields': fields.map((f) => f.toJson()).toList(),
      };

  CategoryModel copyWith({
    String? id,
    String? label,
    String? icon,
    int? colorValue,
    List<FieldDefinition>? fields,
  }) =>
      CategoryModel(
        id: id ?? this.id,
        label: label ?? this.label,
        icon: icon ?? this.icon,
        colorValue: colorValue ?? this.colorValue,
        fields: fields ?? this.fields,
      );

  List<String> get fieldKeys =>
      (List<FieldDefinition>.from(fields)..sort((a, b) => a.order.compareTo(b.order)))
          .map((f) => f.key)
          .toList();
}
