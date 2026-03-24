// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../models/category_model.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'list_screen.dart';
import 'compare_screen.dart';
import 'settings_screen.dart';
import 'admin/admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<MaterialItem> _compareList = [];

  void _toggleCompare(MaterialItem item) {
    setState(() {
      if (_compareList.any((i) => i.id == item.id)) {
        _compareList.removeWhere((i) => i.id == item.id);
      } else if (_compareList.length < 3) {
        _compareList.add(item);
      } else {
        final s = context.read<AppState>().s;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(s.maxCompare),
          backgroundColor: AppColors.surface,
        ));
      }
    });
  }

  void _goToList({CategoryModel? category, String query = ''}) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ListScreen(
        initialCategory: category,
        initialQuery: query,
        compareList: _compareList,
        onToggleCompare: _toggleCompare,
      ),
    )).then((_) => setState(() {}));
  }

  void _goToCompare() {
    if (_compareList.isEmpty) return;
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => CompareScreen(
        items: _compareList,
        onRemove: (item) =>
            setState(() => _compareList.removeWhere((i) => i.id == item.id)),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.s;
    final categories = state.categories;
    final recentItems = state.items.take(4).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          _TopBar(s: s, compareCount: _compareList.length, onGoToCompare: _goToCompare),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              children: [
                Text(s.greeting, style: AppTextStyles.heading.copyWith(fontSize: 22)),
                const SizedBox(height: 4),
                Text(s.greetingSub, style: AppTextStyles.caption),
                const SizedBox(height: 28),
                Text(s.categoryTitle, style: AppTextStyles.sectionLabel),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12, crossAxisSpacing: 12,
                  childAspectRatio: 1.65,
                  children: categories.map((cat) => _CategoryCard(
                    category: cat,
                    localizedName: s.catName(cat.id, cat.label), //hiển thị tên cat ==== cat name
                    count: state.countByCategory(cat.id),
                    itemLabel: s.itemCount,
                    onTap: () => _goToList(category: cat),
                  )).toList(),
                ),
                const SizedBox(height: 28),
                Text(s.recentTitle, style: AppTextStyles.sectionLabel),
                const SizedBox(height: 12),
                ...recentItems.map((item) {
                  final cat = state.getCategoryById(item.categoryId);
                  if (cat == null) return const SizedBox.shrink();
                  return _MiniCard(
                    item: item, category: cat,
                    onTap: () => _goToList(query: item.name),
                  );
                }),
              ],
            ),
          ),
        ]),
      ),
      floatingActionButton: _compareList.isNotEmpty
          ? _CompareBar(
              count: _compareList.length,
              names: _compareList.map((i) => i.name.split(' ').last).join(' · '),
              label: s.compareBar, viewLabel: s.compareView,
              onTap: _goToCompare,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: _BottomNav(
        s: s, compareCount: _compareList.length,
        onCatalog: () => _goToList(),
        onCompare: _goToCompare,
        onSettings: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SettingsScreen())),
        onAdmin: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AdminScreen())),
        isAdmin: state.isAdminMode,
      ),
    );
  }
}

// ── TOPBAR ────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final s;
  final int compareCount;
  final VoidCallback onGoToCompare;

  const _TopBar({required this.s, required this.compareCount, required this.onGoToCompare});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: AppDecorations.topBar(),
      child: Column(children: [
        Row(children: [
          const Text('❄', style: TextStyle(fontSize: 22, color: AppColors.accent)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.appName, style: const TextStyle(fontSize: 15,
                  fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                  letterSpacing: 0.5)),
              Text(s.appSub, style: const TextStyle(fontSize: 11,
                  color: AppColors.textSecondary, letterSpacing: 0.5)),
            ]),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsScreen())),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface, borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.language_rounded,
                  color: AppColors.accent, size: 18),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => ListScreen(
                initialQuery: '', compareList: const [],
                onToggleCompare: (_) {},
              ))),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.surface, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [
              const Icon(Icons.search, color: AppColors.accent, size: 18),
              const SizedBox(width: 8),
              Text(s.searchHint,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ── CATEGORY CARD ─────────────────────────────────────────────────────────────
class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final String localizedName;
  final int count;
  final String itemLabel;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category, required this.localizedName,
    required this.count, required this.itemLabel, required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: AppDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(category.icon, style: TextStyle(fontSize: 22, color: category.color)),
          const SizedBox(height: 6),
          Text(localizedName, style: const TextStyle(fontSize: 13,
              fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          Text('$count $itemLabel',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    ),
  );
}

// ── MINI CARD ─────────────────────────────────────────────────────────────────
class _MiniCard extends StatelessWidget {
  final item, category;
  final VoidCallback onTap;

  const _MiniCard({required this.item, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final firstSpec = item.specs.entries.first;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: AppDecorations.card(),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text(category.icon,
                style: TextStyle(fontSize: 16, color: category.color))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.name, style: const TextStyle(fontSize: 13,
                fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            Text('${firstSpec.key}: ${firstSpec.value}',
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ])),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
        ]),
      ),
    );
  }
}

// ── COMPARE BAR ───────────────────────────────────────────────────────────────
class _CompareBar extends StatelessWidget {
  final int count;
  final String names, label, viewLabel;
  final VoidCallback onTap;

  const _CompareBar({required this.count, required this.names,
      required this.label, required this.viewLabel, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface2, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent),
        boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.2),
            blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
          children: [
            Text('$label ($count/3)', style: const TextStyle(fontSize: 12,
                fontWeight: FontWeight.w700, color: AppColors.accent)),
            Text(names, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ]),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(color: AppColors.accent,
              borderRadius: BorderRadius.circular(8)),
          child: Text(viewLabel, style: const TextStyle(fontSize: 13,
              fontWeight: FontWeight.w700, color: AppColors.bg)),
        ),
      ]),
    ),
  );
}

// ── BOTTOM NAV ────────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final s;
  final int compareCount;
  final VoidCallback onCatalog, onCompare, onSettings, onAdmin;
  final bool isAdmin;

  const _BottomNav({
    required this.s, required this.compareCount,
    required this.onCatalog, required this.onCompare,
    required this.onSettings, required this.onAdmin, required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: AppDecorations.bottomNav(),
      child: Row(children: [
        _NavItem(icon: Icons.grid_view_rounded, label: s.navHome, active: true, onTap: () {}),
        _NavItem(icon: Icons.list_rounded, label: s.navCatalog, onTap: onCatalog),
        _NavItem(icon: Icons.compare_arrows_rounded, label: s.navCompare,
            badge: compareCount, onTap: onCompare),
        _NavItem(
          icon: isAdmin ? Icons.admin_panel_settings : Icons.admin_panel_settings_outlined,
          label: s.navAdmin,
          active: isAdmin,
          activeColor: AppColors.warning,
          onTap: onAdmin,
        ),
      ]),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final int badge;
  final Color? activeColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon, required this.label, this.active = false,
    this.badge = 0, this.activeColor, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final col = active ? (activeColor ?? AppColors.accent) : AppColors.textMuted;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(clipBehavior: Clip.none, children: [
            Icon(icon, color: col, size: 22),
            if (badge > 0) Positioned(
              top: -4, right: -6,
              child: Container(
                width: 16, height: 16,
                decoration: const BoxDecoration(
                    color: AppColors.accent, shape: BoxShape.circle),
                child: Center(child: Text('$badge', style: const TextStyle(
                    fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.bg))),
              ),
            ),
          ]),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 10,
              fontWeight: FontWeight.w600, color: col)),
        ]),
      ),
    );
  }
}
