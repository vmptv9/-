// lib/screens/admin/schema_editor_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category_model.dart';
import '../../models/field_definition.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class SchemaEditorScreen extends StatefulWidget {
  const SchemaEditorScreen({super.key});

  @override
  State<SchemaEditorScreen> createState() => _SchemaEditorScreenState();
}

class _SchemaEditorScreenState extends State<SchemaEditorScreen> {
  String? _selectedCatId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.s;
    final categories = state.categories;

    final selectedCat = _selectedCatId != null
        ? state.getCategoryById(_selectedCatId!)
        : null;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          // HEADER
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
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.schemaEditor, style: const TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text(s.schemaTitle, style: AppTextStyles.caption),
                ]),
              ),
            ]),
          ),

          // BODY
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Category selector
                Text(s.selectCategory.toUpperCase(), style: AppTextStyles.sectionLabel),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: categories.map((cat) => GestureDetector(
                    onTap: () => setState(() => _selectedCatId = cat.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: _selectedCatId == cat.id
                            ? cat.color.withOpacity(0.18) : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedCatId == cat.id
                              ? cat.color : AppColors.border,
                          width: _selectedCatId == cat.id ? 1.5 : 1,
                        ),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(cat.icon, style: TextStyle(
                            fontSize: 16, color: cat.color)),
                        const SizedBox(width: 6),
                        Text(s.catName(cat.id), style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600,
                            color: _selectedCatId == cat.id
                                ? cat.color : AppColors.textPrimary)),
                      ]),
                    ),
                  )).toList(),
                ),

                if (selectedCat != null) ...[
                  const SizedBox(height: 28),
                  Row(children: [
                    Expanded(child: Text(s.fieldName.toUpperCase(),
                        style: AppTextStyles.sectionLabel)),
                    GestureDetector(
                      onTap: () => _addField(context, selectedCat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.accent.withOpacity(0.5)),
                        ),
                        child: Text(s.addField, style: const TextStyle(
                            fontSize: 12, color: AppColors.accent,
                            fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _FieldsList(
                    category: selectedCat,
                    onUpdate: (fields) {
                      context.read<AppState>().updateCategory(
                          selectedCat.copyWith(fields: fields));
                    },
                  ),
                ] else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: Column(children: [
                      const Text('📋', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 12),
                      Text(s.selectCategory, style: AppTextStyles.caption),
                    ])),
                  ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void _addField(BuildContext context, CategoryModel cat) {
    final ctrl = TextEditingController();
    bool isRequired = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(context.read<AppState>().s.addField,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: ctrl,
              autofocus: true,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
              decoration: AppDecorations.formField('Tên trường (vd: Φ Ngoài)'),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Checkbox(
                value: isRequired,
                onChanged: (v) => setS(() => isRequired = v ?? false),
                activeColor: AppColors.accent,
              ),
              const Text('Bắt buộc nhập',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ]),
          ]),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.read<AppState>().s.cancel,
                  style: const TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                if (ctrl.text.trim().isEmpty) return;
                final newFields = [...cat.fields,
                  FieldDefinition(
                    key: ctrl.text.trim(),
                    isRequired: isRequired,
                    order: cat.fields.length,
                  )
                ];
                context.read<AppState>().updateCategory(
                    cat.copyWith(fields: newFields));
                Navigator.pop(ctx);
                setState(() {});
              },
              child: Text(context.read<AppState>().s.save,
                  style: const TextStyle(color: AppColors.accent,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldsList extends StatelessWidget {
  final CategoryModel category;
  final Function(List<FieldDefinition>) onUpdate;

  const _FieldsList({required this.category, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>().s;
    final fields = List<FieldDefinition>.from(category.fields)
      ..sort((a, b) => a.order.compareTo(b.order));

    if (fields.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: AppDecorations.card(),
        child: Center(child: Text('Chưa có trường nào',
            style: AppTextStyles.caption)),
      );
    }

    return Container(
      decoration: AppDecorations.card(),
      child: ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: fields.length,
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) newIndex--;
          final updated = List<FieldDefinition>.from(fields);
          final item = updated.removeAt(oldIndex);
          updated.insert(newIndex, item);
          onUpdate(updated.asMap().entries
              .map((e) => e.value.copyWith(order: e.key))
              .toList());
        },
        itemBuilder: (_, i) {
          final field = fields[i];
          return Container(
            key: ValueKey(field.key),
            decoration: BoxDecoration(
              color: i % 2 == 0 ? AppColors.surface : AppColors.surface2,
              border: i < fields.length - 1
                  ? const Border(bottom: BorderSide(color: AppColors.border))
                  : null,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 4),
              leading: const Icon(Icons.drag_indicator_rounded,
                  color: AppColors.textMuted, size: 20),
              title: Text(field.key, style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
              subtitle: field.isRequired
                  ? Text(s.requiredField, style: const TextStyle(
                      fontSize: 11, color: AppColors.warning))
                  : null,
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                // Toggle required
                GestureDetector(
                  onTap: () {
                    final updated = fields.map((f) => f.key == field.key
                        ? f.copyWith(isRequired: !f.isRequired) : f).toList();
                    onUpdate(updated);
                  },
                  child: Icon(
                    field.isRequired ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: field.isRequired ? AppColors.warning : AppColors.textMuted,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                // Delete
                GestureDetector(
                  onTap: () {
                    final updated =
                        fields.where((f) => f.key != field.key).toList();
                    onUpdate(updated);
                  },
                  child: const Icon(Icons.remove_circle_outline,
                      color: AppColors.danger, size: 20),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
