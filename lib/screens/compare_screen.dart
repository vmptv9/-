// lib/screens/compare_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class CompareScreen extends StatelessWidget {
  final List<MaterialItem> items;
  final Function(MaterialItem) onRemove;

  const CompareScreen({super.key, required this.items, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.s;

    final allKeys = <String>{};
    for (final item in items) allKeys.addAll(item.specs.keys);
    final keyList = allKeys.toList();

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
              Expanded(child: Text(s.compareTitle, style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary))),
              Text('${items.length}/3',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ]),
          ),
          if (items.length < 2)
            Expanded(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('⚖️', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(s.compareEmpty,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 8),
              Text(s.compareEmptySub,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ])))
          else
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 40),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(20),
                  child: _CompareTable(
                    items: items, keyList: keyList,
                    getCategory: state.getCategoryById,
                    onRemove: onRemove, s: s,
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

class _CompareTable extends StatelessWidget {
  final List<MaterialItem> items;
  final List<String> keyList;
  final CategoryModel? Function(String) getCategory;
  final Function(MaterialItem) onRemove;
  final s;

  const _CompareTable({
    required this.items, required this.keyList,
    required this.getCategory, required this.onRemove, required this.s,
  });

  @override
  Widget build(BuildContext context) {
    const kw = 130.0;
    const vw = 165.0;

    return Table(
      columnWidths: {
        0: const FixedColumnWidth(kw),
        for (int i = 1; i <= items.length; i++) i: const FixedColumnWidth(vw),
      },
      border: TableBorder.all(color: AppColors.border, width: 1),
      children: [
        // HEADER
        TableRow(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            color: AppColors.surface,
            child: Text(s.compareParam, style: const TextStyle(fontSize: 11,
                color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
          ),
          ...items.map((item) {
            final cat = getCategory(item.categoryId);
            return _ItemHeader(item: item, category: cat, onRemove: onRemove);
          }),
        ]),
        // ROWS
        ...keyList.asMap().entries.map((entry) {
          final i = entry.key;
          final key = entry.value;
          final vals = items.map((item) => item.specs[key] ?? '—').toList();
          final allSame = vals.every((v) => v == vals.first);
          return TableRow(
            decoration: BoxDecoration(
                color: i % 2 == 0 ? AppColors.surface : AppColors.surface2),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text(s.specKey(key), style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500)),
              ),
              ...vals.map((v) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                color: (!allSame && v != '—')
                    ? AppColors.accent.withOpacity(0.08) : null,
                child: Text(v, style: TextStyle(fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: (!allSame && v != '—')
                        ? AppColors.accent : AppColors.textPrimary)),
              )),
            ],
          );
        }),
      ],
    );
  }
}

class _ItemHeader extends StatelessWidget {
  final MaterialItem item;
  final CategoryModel? category;
  final Function(MaterialItem) onRemove;

  const _ItemHeader({required this.item, required this.category, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final color = category?.color ?? AppColors.accent;
    return Container(
      padding: const EdgeInsets.all(10),
      color: color.withOpacity(0.12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(item.name, style: TextStyle(fontSize: 12,
              fontWeight: FontWeight.w700, color: color),
              maxLines: 2, overflow: TextOverflow.ellipsis)),
          GestureDetector(
            onTap: () => onRemove(item),
            child: Icon(Icons.close_rounded, color: color, size: 16),
          ),
        ]),
        const SizedBox(height: 2),
        Text(item.brand, style: const TextStyle(
            fontSize: 10, color: AppColors.textSecondary)),
      ]),
    );
  }
}
