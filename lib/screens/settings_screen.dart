// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppLanguage _selected;

  @override
  void initState() {
    super.initState();
    _selected = context.read<AppState>().language;
  }

  void _apply() {
    context.read<AppState>().setLanguage(_selected);
    Navigator.pop(context);
  }

  void _confirmReset() {
    final s = context.read<AppState>().s;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(s.resetData,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: Text(s.resetConfirm,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AppState>().resetToSeedData();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('✓ Đã khôi phục dữ liệu gốc'),
                backgroundColor: AppColors.surface,
              ));
            },
            child: Text(s.confirm,
                style: const TextStyle(
                    color: AppColors.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>().s;

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
              Text(s.settingsTitle,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 8),
                Text(s.languageTitle.toUpperCase(),
                    style: AppTextStyles.sectionLabel),
                const SizedBox(height: 4),
                Text(s.languageSubtitle, style: AppTextStyles.caption),
                const SizedBox(height: 16),
                _LangOption(
                    flag: '🇻🇳',
                    name: 'Tiếng Việt',
                    sub: 'Vietnamese',
                    selected: _selected == AppLanguage.vi,
                    color: const Color(0xFFEF4444),
                    onTap: () => setState(() => _selected = AppLanguage.vi)),
                const SizedBox(height: 10),
                _LangOption(
                    flag: '🇹🇼',
                    name: '繁體中文（台灣）',
                    sub: 'Traditional Chinese · Taiwan',
                    selected: _selected == AppLanguage.zh,
                    color: AppColors.accent,
                    onTap: () => setState(() => _selected = AppLanguage.zh)),
                const SizedBox(height: 10),
                _LangOption(
                    flag: '🇬🇧',
                    name: 'English',
                    sub: 'English (United Kingdom)',
                    selected: _selected == AppLanguage.en,
                    color: AppColors.success,
                    onTap: () => setState(() => _selected = AppLanguage.en)),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: _apply,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.accent.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Center(
                        child: Text(s.apply,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.bg))),
                  ),
                ),
                const SizedBox(height: 32),
                Text('DATA', style: AppTextStyles.sectionLabel),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _confirmReset,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppDecorations.card(),
                    child: Row(children: [
                      const Icon(Icons.restore_rounded,
                          color: AppColors.warning, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(s.resetData,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w600))),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textMuted, size: 18),
                    ]),
                  ),
                ),
                const SizedBox(height: 32),
                Text('ABOUT', style: AppTextStyles.sectionLabel),
                const SizedBox(height: 12),
                Container(
                  decoration: AppDecorations.card(),
                  child: Column(children: [
                    _AboutRow('App', context.read<AppState>().s.appName),
                    _AboutRow('Version', '1.0.0'),
                    _AboutRow('Author', '武明峰AlexWU'), // <--  tác giả
                    _AboutRow('冷凍空調', 'Refrigeration & HVAC'),
                    _AboutRow('Platform', 'Flutter · iOS / Android',
                        last: true),
                  ]),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final String flag, name, sub;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _LangOption(
      {required this.flag,
      required this.name,
      required this.sub,
      required this.selected,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: selected ? color : AppColors.border,
                width: selected ? 1.5 : 1),
          ),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(flag, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(name,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: selected ? color : AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(sub,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                ])),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? color : Colors.transparent,
                  border: Border.all(
                      color: selected ? color : AppColors.textMuted, width: 2)),
              child: selected
                  ? const Center(
                      child: Icon(Icons.check_rounded,
                          color: AppColors.bg, size: 13))
                  : null,
            ),
          ]),
        ),
      );
}

class _AboutRow extends StatelessWidget {
  final String label, value;
  final bool last;

  const _AboutRow(this.label, this.value, {this.last = false});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: last
            ? null
            : const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border))),
        child: Row(children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600)),
        ]),
      );
}
