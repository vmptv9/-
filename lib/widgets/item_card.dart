// lib/widgets/item_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'spec_pill.dart';

class ItemCard extends StatelessWidget {
  final MaterialItem item;
  final CategoryModel category;
  final bool inCompare;
  final VoidCallback onTap;
  final VoidCallback onToggleCompare;

  const ItemCard({
    super.key,
    required this.item,
    required this.category,
    required this.inCompare,
    required this.onTap,
    required this.onToggleCompare,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>().s;
    final firstSpecs = item.specs.entries.take(3).toList();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.card(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: AppTextStyles.subheading),
                      const SizedBox(height: 3),
                      Text('${item.brand} · ${category.label}',
                          style: AppTextStyles.caption),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onToggleCompare,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: inCompare ? category.color : AppColors.textMuted),
                      color: inCompare
                          ? category.color.withOpacity(0.15)
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        inCompare ? '✓' : '+',
                        style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700,
                          color: inCompare ? category.color : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6, runSpacing: 6,
              children: firstSpecs
                  .map((e) => SpecPill(
                        text: '${s.specKey(e.key)}: ${e.value}',
                        color: category.color,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
