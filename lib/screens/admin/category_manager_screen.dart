// lib/screens/admin/category_manager_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category_model.dart';
import '../../models/field_definition.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class CategoryManagerScreen extends StatelessWidget {
  const CategoryManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.s;
    final categories = state.categories;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            decoration: AppDecorations.topBar(),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.accent, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(s.manageCategories,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary))),
              GestureDetector(
                onTap: () => _showAddEdit(context, null),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(s.addCategory,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.bg)),
                ),
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final cat = categories[i];
                final count = state.countByCategory(cat.id);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration:
                      // ignore: deprecated_member_use
                      AppDecorations.card(border: cat.color.withOpacity(0.3)),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: cat.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(cat.icon,
                              style:
                                  TextStyle(fontSize: 22, color: cat.color))),
                    ),
                    title: Text(cat.label,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    subtitle: Text(
                      '$count ${s.totalItems} · ${cat.fields.length} trường',
                      style: AppTextStyles.caption,
                    ),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.accent, size: 18),
                        onPressed: () => _showAddEdit(context, cat),
                      ),
                      if (cat.id != 'pipe' &&
                          cat.id != 'wire' &&
                          cat.id != 'fcu' &&
                          cat.id != 'chiller' &&
                          cat.id != 'fitting' &&
                          cat.id != 'ctrl')
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.danger, size: 18),
                          onPressed: () => _confirmDelete(context, cat),
                        ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  void _confirmDelete(BuildContext context, CategoryModel cat) {
    final s = context.read<AppState>().s;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(s.editCategory,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: Text(s.deleteCategoryConfirm,
            style: const TextStyle(color: AppColors.danger, fontSize: 13)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(s.cancel,
                  style: const TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AppState>().deleteCategory(cat.id);
            },
            child: Text(s.delete,
                style: const TextStyle(
                    color: AppColors.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showAddEdit(BuildContext context, CategoryModel? cat) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => _AddEditCategoryScreen(category: cat)));
  }
}

// ── ADD / EDIT CATEGORY ───────────────────────────────────────────────────────
class _AddEditCategoryScreen extends StatefulWidget {
  final CategoryModel? category;

  const _AddEditCategoryScreen({this.category});

  @override
  State<_AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<_AddEditCategoryScreen> {
  final _labelCtrl = TextEditingController();
  final _iconCtrl = TextEditingController();
  // ignore: deprecated_member_use
  int _colorValue = AppColors.categoryColors[0].value;
  final _formKey = GlobalKey<FormState>();

  bool get _isEdit => widget.category != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _labelCtrl.text = widget.category!.label;
      _iconCtrl.text = widget.category!.icon;
      _colorValue = widget.category!.colorValue;
    } else {
      _iconCtrl.text = '⬤';
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _iconCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final state = context.read<AppState>();
    final s = state.s;

    if (_isEdit) {
      state.updateCategory(widget.category!.copyWith(
        label: _labelCtrl.text.trim(),
        icon: _iconCtrl.text.trim(),
        colorValue: _colorValue,
      ));
    } else {
      final newId = 'cat_${DateTime.now().millisecondsSinceEpoch}';
      state.addCategory(CategoryModel(
        id: newId,
        label: _labelCtrl.text.trim(),
        icon: _iconCtrl.text.trim(),
        colorValue: _colorValue,
        fields: [
          const FieldDefinition(key: 'Tên', isRequired: true, order: 0),
          const FieldDefinition(key: 'Quy cách', isRequired: false, order: 1),
          const FieldDefinition(key: 'Ghi chú', isRequired: false, order: 2),
        ],
      ));
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('✓ Đã ${_isEdit ? "cập nhật" : "thêm"} danh mục'),
      backgroundColor: AppColors.surface,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>().s;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              decoration: AppDecorations.topBar(),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.accent, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(
                  _isEdit ? s.editCategory : s.addCategory,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                )),
                GestureDetector(
                  onTap: _save,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(s.save,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.bg)),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Preview
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Color(_colorValue).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            // ignore: deprecated_member_use
                            color: Color(_colorValue).withOpacity(0.5)),
                      ),
                      child: Center(
                        child: Text(_iconCtrl.text,
                            style: TextStyle(
                                fontSize: 36, color: Color(_colorValue))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Label
                  Text(s.categoryLabel.toUpperCase(),
                      style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _labelCtrl,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                    decoration: AppDecorations.formField(s.categoryLabel,
                        hint: 'vd: Vật liệu cách nhiệt'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Không được để trống'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // Icon
                  Text(s.categoryIcon.toUpperCase(),
                      style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _iconCtrl,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 20),
                    decoration: AppDecorations.formField(s.categoryIcon,
                        hint: 'vd: 🧊 ❄ ⚙ ○'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Không được để trống'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // Color picker
                  Text(s.categoryColor.toUpperCase(),
                      style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: AppColors.categoryColors.map((color) {
                      // ignore: deprecated_member_use
                      final isSelected = _colorValue == color.value;
                      return GestureDetector(
                        onTap: () =>
                            // ignore: deprecated_member_use
                            setState(() => _colorValue = color.value),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    // ignore: deprecated_member_use
                                    BoxShadow(
                                        // ignore: deprecated_member_use
                                        color: color.withOpacity(0.6),
                                        blurRadius: 8,
                                        spreadRadius: 2)
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 20)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
