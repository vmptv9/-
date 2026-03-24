// lib/providers/app_state.dart
import 'package:flutter/foundation.dart';
import '../data/seed_data.dart';
import '../l10n/app_strings.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';
import '../services/data_service.dart';

class AppState extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  List<MaterialItem> _items = [];
  AppLanguage _language = AppLanguage.vi;
  bool _isAdminMode = false;
  bool _isLoading = true;

  static const _adminPin = '1234';
  final _dataService = DataService();

  // ── GETTERS ───────────────────────────────────────────────────
  List<CategoryModel> get categories => List.unmodifiable(_categories);
  List<MaterialItem> get items => List.unmodifiable(_items);
  AppLanguage get language => _language;
  bool get isAdminMode => _isAdminMode;
  bool get isLoading => _isLoading;
  AppStrings get s => AppStrings(_language);

  // ── INIT ──────────────────────────────────────────────────────
  Future<void> initialize() async {
    final saved = await _dataService.load();
    if (saved != null) {
      _categories = saved.categories;
      _items = saved.items;
      _language = saved.language;
    } else {
      _categories = SeedData.categories;
      _items = SeedData.items;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _persist() async {
    await _dataService.save(AppData(
      categories: _categories,
      items: _items,
      language: _language,
    ));
  }

  // ── RESET ─────────────────────────────────────────────────────
  Future<void> resetToSeedData() async {
    await _dataService.clearAll();
    _categories = SeedData.categories;
    _items = SeedData.items;
    await _persist();
    notifyListeners();
  }

  // ── LANGUAGE ──────────────────────────────────────────────────
  void setLanguage(AppLanguage lang) {
    _language = lang;
    _persist();
    notifyListeners();
  }

  // ── ADMIN ─────────────────────────────────────────────────────
  bool unlockAdmin(String pin) {
    if (pin == _adminPin) {
      _isAdminMode = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void lockAdmin() {
    _isAdminMode = false;
    notifyListeners();
  }

  // ── CATEGORIES ────────────────────────────────────────────────
  void addCategory(CategoryModel cat) {
    _categories = [..._categories, cat];
    _persist();
    notifyListeners();
  }

  void updateCategory(CategoryModel cat) {
    _categories = [
      for (final c in _categories) c.id == cat.id ? cat : c,
    ];
    _persist();
    notifyListeners();
  }

  void deleteCategory(String id) {
    _categories = _categories.where((c) => c.id != id).toList();
    _items = _items.where((i) => i.categoryId != id).toList();
    _persist();
    notifyListeners();
  }

  // ── ITEMS ─────────────────────────────────────────────────────
  void addItem(MaterialItem item) {
    _items = [..._items, item];
    _persist();
    notifyListeners();
  }

  void updateItem(MaterialItem item) {
    _items = [
      for (final i in _items) i.id == item.id ? item : i,
    ];
    _persist();
    notifyListeners();
  }

  void deleteItem(String id) {
    _items = _items.where((i) => i.id != id).toList();
    _persist();
    notifyListeners();
  }

  // ── QUERIES ───────────────────────────────────────────────────
  CategoryModel? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<MaterialItem> getItemsByCategory(String catId) =>
      _items.where((i) => i.categoryId == catId).toList();

  int countByCategory(String catId) =>
      _items.where((i) => i.categoryId == catId).length;

  List<MaterialItem> search(String query, {String? catId}) {
    var result = catId != null
        ? _items.where((i) => i.categoryId == catId).toList()
        : List<MaterialItem>.from(_items);

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      result = result.where((i) =>
          i.name.toLowerCase().contains(q) ||
          i.brand.toLowerCase().contains(q) ||
          i.specs.values.any((v) => v.toLowerCase().contains(q))).toList();
    }
    return result;
  }
}
