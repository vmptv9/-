// lib/services/data_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';
import '../l10n/app_strings.dart';

class AppData {
  final List<CategoryModel> categories;
  final List<MaterialItem> items;
  final AppLanguage language;

  const AppData({
    required this.categories,
    required this.items,
    required this.language,
  });
}

class DataService {
  static const _keyCategories = 'hvac_categories';
  static const _keyItems = 'hvac_items';
  static const _keyLanguage = 'hvac_language';
  static const _keyInitialized = 'hvac_initialized';

  Future<AppData?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final initialized = prefs.getBool(_keyInitialized) ?? false;
      if (!initialized) return null;

      final catJson = prefs.getString(_keyCategories);
      final itemJson = prefs.getString(_keyItems);
      final langStr = prefs.getString(_keyLanguage) ?? 'vi';

      if (catJson == null || itemJson == null) return null;

      final cats = (jsonDecode(catJson) as List)
          .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
          .toList();
      final items = (jsonDecode(itemJson) as List)
          .map((i) => MaterialItem.fromJson(i as Map<String, dynamic>))
          .toList();

      final lang = AppLanguage.values.firstWhere(
        (l) => l.name == langStr,
        orElse: () => AppLanguage.vi,
      );

      return AppData(categories: cats, items: items, language: lang);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(AppData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _keyCategories, jsonEncode(data.categories.map((c) => c.toJson()).toList()));
      await prefs.setString(
          _keyItems, jsonEncode(data.items.map((i) => i.toJson()).toList()));
      await prefs.setString(_keyLanguage, data.language.name);
      await prefs.setBool(_keyInitialized, true);
    } catch (_) {}
  }

  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyCategories);
      await prefs.remove(_keyItems);
      await prefs.remove(_keyLanguage);
      await prefs.remove(_keyInitialized);
    } catch (_) {}
  }
}
