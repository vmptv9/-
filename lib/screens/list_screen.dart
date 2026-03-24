// lib/screens/list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/item_card.dart';
import 'detail_screen.dart';

class ListScreen extends StatefulWidget {
  final CategoryModel? initialCategory;
  final String initialQuery;
  final List<MaterialItem> compareList;
  final Function(MaterialItem) onToggleCompare;

  const ListScreen({
    super.key,
    this.initialCategory,
    this.initialQuery = '',
    required this.compareList,
    required this.onToggleCompare,
  });

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late TextEditingController _ctrl;
  String? _activeCatId;

  @override
  void initState() {
    super.initState();
    _activeCatId = widget.initialCategory?.id;
    _ctrl = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.s;
    final categories = state.categories;

    final results = state.search(_ctrl.text, catId: _activeCatId);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          // ── TOP BAR ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: AppDecorations.topBar(),
            child: Column(children: [
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.accent, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.surface, borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(children: [
                      const Icon(Icons.search, color: AppColors.accent, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          onChanged: (_) => setState(() {}),
                          autofocus: widget.initialQuery.isEmpty &&
                              widget.initialCategory == null,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 14),
                          decoration: InputDecoration(
                            isDense: true, border: InputBorder.none,
                            hintText: s.searchHint,
                            hintStyle: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 14),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (_ctrl.text.isNotEmpty)
                        GestureDetector(
                          onTap: () => setState(() => _ctrl.clear()),
                          child: const Icon(Icons.close,
                              color: AppColors.textMuted, size: 16),
                        ),
                    ]),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              // Filter chips
              SizedBox(
                height: 32,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _Chip(label: s.allFilter, active: _activeCatId == null,
                        color: AppColors.accent,
                        onTap: () => setState(() => _activeCatId = null)),
                    const SizedBox(width: 6),
                    ...categories.map((cat) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: _Chip(
                        label: '${cat.icon} ${cat.label}',
                        active: _activeCatId == cat.id,
                        color: cat.color,
                        onTap: () => setState(() =>
                        _activeCatId = _activeCatId == cat.id ? null : cat.id),
                      ),
                    )),
                  ],
                ),
              ),
            ]),
          ),

          // ── COUNT ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${results.length} ${s.results}'
                '${_ctrl.text.isNotEmpty ? ' ${s.resultsFor} "${_ctrl.text}"' : ''}',
                style: AppTextStyles.caption,
              ),
            ),
          ),

          // ── LIST ──
          Expanded(
            child: results.isEmpty
                ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text('🔍', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text(s.noResults,
                        style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(s.noResultsSub,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ]))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 80),
                    itemCount: results.length,
                    itemBuilder: (_, i) {
                      final item = results[i];
                      final cat = state.getCategoryById(item.categoryId);
                      if (cat == null) return const SizedBox.shrink();
                      final inCompare =
                          widget.compareList.any((c) => c.id == item.id);
                      return ItemCard(
                        item: item, category: cat, inCompare: inCompare,
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => DetailScreen(
                            item: item, category: cat, inCompare: inCompare,
                            onToggleCompare: () => widget.onToggleCompare(item),
                          ),
                        )).then((_) => setState(() {})),
                        onToggleCompare: () {
                          widget.onToggleCompare(item);
                          setState(() {});
                        },
                      );
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.active,
      required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.15) : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? color : AppColors.border),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
          color: active ? color : AppColors.textSecondary)),
    ),
  );
}
