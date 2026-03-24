// lib/screens/detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/spec_pill.dart';
import 'admin/add_edit_item_screen.dart';

class DetailScreen extends StatefulWidget {
  final MaterialItem item;
  final CategoryModel category;
  final bool inCompare;
  final VoidCallback onToggleCompare;

  const DetailScreen({
    super.key,
    required this.item,
    required this.category,
    required this.inCompare,
    required this.onToggleCompare,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool _inCompare;
  late MaterialItem _item;

  @override
  void initState() {
    super.initState();
    _inCompare = widget.inCompare;
    _item = widget.item;
  }

  void _copyToClipboard() {
    final s = context.read<AppState>().s;
    final buf = StringBuffer();
    buf.writeln('📦 ${_item.name}');
    buf.writeln('🏭 ${s.brand}: ${_item.brand}');
    buf.writeln('📂 ${widget.category.label}');
    buf.writeln('');
    _item.specs.forEach((k, v) => buf.writeln('  • ${s.specKey(k)}: $v'));
    Clipboard.setData(ClipboardData(text: buf.toString()));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(context.read<AppState>().s.copied),
      backgroundColor: AppColors.surface,
      duration: const Duration(seconds: 2),
    ));
  }

  void _deleteItem() {
    final s = context.read<AppState>().s;
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: s.deleteItem,
        message: s.deleteItemConfirm,
        confirmLabel: s.delete,
        confirmColor: AppColors.danger,
        onConfirm: () {
          context.read<AppState>().deleteItem(_item.id);
          Navigator.pop(context); // close dialog
          Navigator.pop(context); // go back to list
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.s;
    // Reload item in case it was edited
    final freshItem = state.items.cast<MaterialItem?>()
        .firstWhere((i) => i?.id == _item.id, orElse: () => null);
    if (freshItem != null) _item = freshItem;

    final specs = _item.specs.entries.toList();

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
              const SizedBox(width: 10),
              Expanded(
                child: Text(widget.category.label, style: TextStyle(
                    fontSize: 13, color: widget.category.color,
                    fontWeight: FontWeight.w600)),
              ),
              if (state.isAdminMode) ...[
                _HeaderBtn(
                  icon: Icons.edit_outlined, label: s.edit,
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) =>
                        AddEditItemScreen(item: _item, category: widget.category),
                  )).then((_) => setState(() {})),
                ),
                const SizedBox(width: 8),
                _HeaderBtn(
                  icon: Icons.delete_outline, label: s.delete,
                  color: AppColors.danger, onTap: _deleteItem,
                ),
              ] else
                _HeaderBtn(
                  icon: Icons.share_outlined, label: s.share,
                  onTap: _copyToClipboard,
                ),
            ]),
          ),

          // ── BODY ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              children: [
                Row(children: [
                  SpecPill(
                    text: '${widget.category.icon} ${widget.category.label}',
                    color: widget.category.color,
                  ),
                ]),
                const SizedBox(height: 12),
                Text(_item.name, style: const TextStyle(fontSize: 22,
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary,
                    height: 1.3)),
                const SizedBox(height: 6),
                Text('${s.brand}: ${_item.brand}', style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                Text(s.specTitle, style: AppTextStyles.sectionLabel),
                const SizedBox(height: 12),

                // Specs table
                Container(
                  decoration: AppDecorations.card(),
                  child: Column(
                    children: specs.asMap().entries.map((entry) {
                      final i = entry.key;
                      final spec = entry.value;
                      final isLast = i == specs.length - 1;
                      return Container(
                        decoration: BoxDecoration(
                          color: i % 2 == 0 ? AppColors.surface : AppColors.surface2,
                          borderRadius: isLast
                              ? const BorderRadius.vertical(bottom: Radius.circular(13))
                              : null,
                          border: isLast
                              ? null
                              : const Border(
                                  bottom: BorderSide(color: AppColors.border)),
                        ),
                        child: Row(children: [
                          SizedBox(
                            width: 150,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              child: Text(s.specKey(spec.key),
                                  style: const TextStyle(fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                          Container(width: 1, height: 38, color: AppColors.border),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              child: Text(spec.value, style: const TextStyle(
                                  fontSize: 13, color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ]),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Actions
                Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.onToggleCompare();
                        setState(() => _inCompare = !_inCompare);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: _inCompare
                              ? widget.category.color.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: widget.category.color),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(
                            _inCompare ? Icons.check_rounded : Icons.compare_arrows_rounded,
                            color: widget.category.color, size: 16),
                          const SizedBox(width: 6),
                          Text(_inCompare ? s.inCompare : s.addCompare,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                  color: widget.category.color)),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _copyToClipboard,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.copy_outlined,
                          color: AppColors.textSecondary, size: 18),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _HeaderBtn({
    required this.icon, required this.label,
    this.color = AppColors.textSecondary, required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: color)),
      ]),
    ),
  );
}

class _ConfirmDialog extends StatelessWidget {
  final String title, message, confirmLabel;
  final Color confirmColor;
  final VoidCallback onConfirm;

  const _ConfirmDialog({
    required this.title, required this.message,
    required this.confirmLabel, required this.confirmColor, required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>().s;
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
      content: Text(message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.cancel, style: const TextStyle(color: AppColors.textSecondary)),
        ),
        TextButton(
          onPressed: () { Navigator.pop(context); onConfirm(); },
          child: Text(confirmLabel, style: TextStyle(color: confirmColor, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
