// lib/screens/admin/add_edit_item_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category_model.dart';
import '../../models/item_model.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class AddEditItemScreen extends StatefulWidget {
  final MaterialItem? item;
  final CategoryModel? category;

  const AddEditItemScreen({super.key, this.item, this.category});

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _nameCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final Map<String, TextEditingController> _specCtrls = {};
  String? _selectedCatId;
  final _formKey = GlobalKey<FormState>();

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _nameCtrl.text = widget.item!.name;
      _brandCtrl.text = widget.item!.brand;
      _selectedCatId = widget.item!.categoryId;
      widget.item!.specs.forEach((k, v) {
        _specCtrls[k] = TextEditingController(text: v);
      });
    } else if (widget.category != null) {
      _selectedCatId = widget.category!.id;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _brandCtrl.dispose();
    for (final c in _specCtrls.values) c.dispose();
    super.dispose();
  }

  void _initSpecControllers(CategoryModel cat) {
    // Add controllers for fields that don't have one yet
    for (final field in cat.fields) {
      if (!_specCtrls.containsKey(field.key)) {
        _specCtrls[field.key] = TextEditingController();
      }
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final state = context.read<AppState>();
    final cat = state.getCategoryById(_selectedCatId!);
    if (cat == null) return;

    final specs = <String, String>{};
    for (final field in cat.fields) {
      final val = _specCtrls[field.key]?.text.trim() ?? '';
      if (val.isNotEmpty) specs[field.key] = val;
    }

    if (_isEdit) {
      state.updateItem(widget.item!.copyWith(
        name: _nameCtrl.text.trim(),
        brand: _brandCtrl.text.trim(),
        specs: specs,
      ));
    } else {
      state.addItem(MaterialItem(
        id: MaterialItem.generateId(),
        categoryId: _selectedCatId!,
        name: _nameCtrl.text.trim(),
        brand: _brandCtrl.text.trim(),
        specs: specs,
        createdAt: DateTime.now(),
      ));
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_isEdit ? '✓ Đã cập nhật vật tư' : '✓ Đã thêm vật tư mới'),
      backgroundColor: AppColors.surface,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.s;
    final categories = state.categories;

    final selectedCat = _selectedCatId != null
        ? state.getCategoryById(_selectedCatId!)
        : null;

    if (selectedCat != null) _initSpecControllers(selectedCat);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(children: [
            // ── HEADER ──
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
                  child: Text(_isEdit ? s.editItem : s.addItem,
                      style: const TextStyle(fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                ),
                GestureDetector(
                  onTap: _save,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(s.save, style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700,
                        color: AppColors.bg)),
                  ),
                ),
              ]),
            ),

            // ── FORM ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Basic info
                  Text('THÔNG TIN CƠ BẢN', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 12),

                  // Category selector
                  _SectionTitle(text: s.selectCategory),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCatId,
                        hint: Text(s.selectCategory,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 13)),
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 13),
                        isExpanded: true,
                        items: categories.map((cat) => DropdownMenuItem(
                          value: cat.id,
                          child: Row(children: [
                            Text(cat.icon, style: TextStyle(
                                fontSize: 16, color: cat.color)),
                            const SizedBox(width: 10),
                            Text(s.catName(cat.id)),
                          ]),
                        )).toList(),
                        onChanged: _isEdit
                            ? null
                            : (v) => setState(() {
                                  _selectedCatId = v;
                                }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Name
                  TextFormField(
                    controller: _nameCtrl,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                    decoration: AppDecorations.formField(s.itemName),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Không được để trống'
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // Brand
                  TextFormField(
                    controller: _brandCtrl,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 14),
                    decoration: AppDecorations.formField(s.itemBrand),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Không được để trống'
                        : null,
                  ),

                  // Spec fields (dynamic based on category schema)
                  if (selectedCat != null) ...[
                    const SizedBox(height: 24),
                    Text(s.specTitle, style: AppTextStyles.sectionLabel),
                    const SizedBox(height: 12),
                    ...selectedCat.fields
                        .where((f) =>
                            _specCtrls.containsKey(f.key))
                        .map((field) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TextFormField(
                            controller: _specCtrls[field.key],
                            style: const TextStyle(
                                color: AppColors.textPrimary, fontSize: 14),
                            decoration: AppDecorations.formField(
                              '${field.key}'
                              '${field.isRequired ? ' *' : ''}',
                            ).copyWith(
                              suffixIcon: field.isRequired
                                  ? const Icon(Icons.star,
                                      color: AppColors.warning, size: 12)
                                  : null,
                            ),
                            validator: field.isRequired
                                ? (v) => (v == null || v.trim().isEmpty)
                                    ? 'Trường bắt buộc'
                                    : null
                                : null,
                          ),
                        )),
                  ] else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(s.selectCategory,
                            style: AppTextStyles.caption),
                      ),
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

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary,
          fontWeight: FontWeight.w500));
}
