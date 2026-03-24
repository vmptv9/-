// lib/screens/admin/admin_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import 'add_edit_item_screen.dart';
import 'schema_editor_screen.dart';
import 'category_manager_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _pinCtrl = TextEditingController();
  bool _pinError = false;

  @override
  void dispose() {
    _pinCtrl.dispose();
    super.dispose();
  }

  void _unlock() {
    final ok = context.read<AppState>().unlockAdmin(_pinCtrl.text.trim());
    if (!ok) setState(() { _pinError = true; _pinCtrl.clear(); });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.s;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
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
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.adminTitle, style: const TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(s.adminSubtitle, style: AppTextStyles.caption),
              ])),
              if (state.isAdminMode)
                GestureDetector(
                  onTap: () {
                    context.read<AppState>().lockAdmin();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.danger.withOpacity(0.5)),
                    ),
                    child: Text(s.adminLock, style: const TextStyle(
                        fontSize: 11, color: AppColors.danger, fontWeight: FontWeight.w600)),
                  ),
                ),
            ]),
          ),

          Expanded(
            child: state.isAdminMode
                ? _AdminDashboard(s: s)
                : _PinEntry(
                    s: s, ctrl: _pinCtrl, error: _pinError,
                    onSubmit: _unlock,
                  ),
          ),
        ]),
      ),
    );
  }
}

// ── PIN ENTRY ─────────────────────────────────────────────────────────────────
class _PinEntry extends StatelessWidget {
  final s;
  final TextEditingController ctrl;
  final bool error;
  final VoidCallback onSubmit;

  const _PinEntry({required this.s, required this.ctrl,
      required this.error, required this.onSubmit});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(40),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.warning.withOpacity(0.4)),
        ),
        child: const Center(child: Icon(Icons.admin_panel_settings,
            color: AppColors.warning, size: 36)),
      ),
      const SizedBox(height: 24),
      Text(s.adminTitle, style: const TextStyle(fontSize: 20,
          fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      Text(s.adminPinHint, style: AppTextStyles.caption,
          textAlign: TextAlign.center),
      const SizedBox(height: 32),
      TextField(
        controller: ctrl,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 8,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16,
            letterSpacing: 6),
        textAlign: TextAlign.center,
        decoration: AppDecorations.formField(s.adminPin).copyWith(
          counterText: '',
          errorText: error ? s.adminPinError : null,
          errorStyle: const TextStyle(color: AppColors.danger, fontSize: 12),
        ),
        onSubmitted: (_) => onSubmit(),
      ),
      const SizedBox(height: 20),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent, foregroundColor: AppColors.bg,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(s.adminUnlock, style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700)),
        ),
      ),
    ]),
  );
}

// ── ADMIN DASHBOARD ───────────────────────────────────────────────────────────
class _AdminDashboard extends StatelessWidget {
  final s;
  const _AdminDashboard({required this.s});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final totalItems = state.items.length;
    final totalCats = state.categories.length;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Stats row
        Row(children: [
          _StatCard(icon: '📦', value: '$totalItems', label: s.totalItems,
              color: AppColors.accent),
          const SizedBox(width: 12),
          _StatCard(icon: '📂', value: '$totalCats', label: 'Categories',
              color: AppColors.success),
        ]),
        const SizedBox(height: 24),

        Text('QUẢN LÝ', style: AppTextStyles.sectionLabel),
        const SizedBox(height: 12),

        _AdminTile(
          icon: Icons.add_circle_outline_rounded,
          title: s.addItem,
          subtitle: 'Thêm vật tư mới vào catalog',
          color: AppColors.accent,
          onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const AddEditItemScreen())),
        ),
        _AdminTile(
          icon: Icons.inventory_2_outlined,
          title: s.manageItems,
          subtitle: 'Xem, sửa, xóa vật tư trong catalog',
          color: AppColors.success,
          onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const _ManageItemsScreen())),
        ),
        _AdminTile(
          icon: Icons.category_outlined,
          title: s.manageCategories,
          subtitle: 'Thêm và quản lý danh mục vật tư',
          color: AppColors.warning,
          onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const CategoryManagerScreen())),
        ),
        _AdminTile(
          icon: Icons.schema_outlined,
          title: s.schemaEditor,
          subtitle: 'Chỉnh sửa trường thông số cho từng danh mục',
          color: const Color(0xFF8B5CF6),
          onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const SchemaEditorScreen())),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon, value, label;
  final Color color;

  const _StatCard({required this.icon, required this.value,
      required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card(border: color.withOpacity(0.3)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800,
            color: color)),
        Text(label, style: AppTextStyles.caption),
      ]),
    ),
  );
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AdminTile({required this.icon, required this.title, required this.subtitle,
      required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card(),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Center(child: Icon(icon, color: color, size: 22)),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 14,
              fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTextStyles.caption),
        ])),
        Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
      ]),
    ),
  );
}

// ── MANAGE ITEMS LIST ─────────────────────────────────────────────────────────
class _ManageItemsScreen extends StatefulWidget {
  const _ManageItemsScreen();

  @override
  State<_ManageItemsScreen> createState() => _ManageItemsScreenState();
}

class _ManageItemsScreenState extends State<_ManageItemsScreen> {
  String _query = '';
  String? _catId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.s;
    final results = state.search(_query, catId: _catId);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
            decoration: AppDecorations.topBar(),
            child: Column(children: [
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.accent, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(s.manageItems, style: const TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const AddEditItemScreen()))
                      .then((_) => setState(() {})),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.accent, borderRadius: BorderRadius.circular(8)),
                    child: Text(s.addItem, style: const TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w700, color: AppColors.bg)),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              // Search
              TextField(
                onChanged: (v) => setState(() => _query = v),
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: AppDecorations.formField(s.searchHint),
              ),
              const SizedBox(height: 8),
              // Category filter
              SizedBox(
                height: 30,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  _CatChip(label: s.allFilter, active: _catId == null,
                      onTap: () => setState(() => _catId = null)),
                  ...state.categories.map((cat) => Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: _CatChip(
                      label: '${cat.icon} ${s.catName(cat.id)}',
                      active: _catId == cat.id, color: cat.color,
                      onTap: () => setState(() =>
                          _catId = _catId == cat.id ? null : cat.id),
                    ),
                  )),
                ]),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Align(alignment: Alignment.centerLeft,
              child: Text('${results.length} ${s.results}', style: AppTextStyles.caption)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
              itemCount: results.length,
              itemBuilder: (_, i) {
                final item = results[i];
                final cat = state.getCategoryById(item.categoryId);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: AppDecorations.card(),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    leading: cat != null ? Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: cat.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text(cat.icon,
                          style: TextStyle(color: cat.color))),
                    ) : null,
                    title: Text(item.name, style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                    subtitle: Text(item.brand, style: AppTextStyles.caption),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.accent, size: 18),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => AddEditItemScreen(
                              item: item, category: cat),
                        )).then((_) => setState(() {})),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AppColors.danger, size: 18),
                        onPressed: () => _confirmDelete(context, item.id, s),
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

  void _confirmDelete(BuildContext context, String id, s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(s.deleteItem, style: const TextStyle(
            color: AppColors.textPrimary, fontSize: 16)),
        content: Text(s.deleteItemConfirm, style: const TextStyle(
            color: AppColors.textSecondary, fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
              child: Text(s.cancel, style: const TextStyle(
                  color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AppState>().deleteItem(id);
            },
            child: Text(s.delete, style: const TextStyle(
                color: AppColors.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _CatChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _CatChip({required this.label, required this.active,
      this.color = AppColors.accent, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.15) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: active ? color : AppColors.border),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
          color: active ? color : AppColors.textSecondary)),
    ),
  );
}
