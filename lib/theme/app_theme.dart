// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppColors {
  static const bg        = Color(0xFF0A0F1E);
  static const surface   = Color(0xFF111827);
  static const surface2  = Color(0xFF0F172A);
  static const border    = Color(0xFF1E293B);
  static const accent    = Color(0xFF38BDF8);
  static const success   = Color(0xFF10B981);
  static const warning   = Color(0xFFF59E0B);
  static const danger    = Color(0xFFEF4444);
  static const textPrimary   = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF64748B);
  static const textMuted     = Color(0xFF475569);

  static const categoryColors = [
    Color(0xFF0EA5E9), Color(0xFF10B981), Color(0xFF8B5CF6),
    Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFFEC4899),
    Color(0xFF14B8A6), Color(0xFF6366F1), Color(0xFFFF7043),
  ];
}

class AppTextStyles {
  static const heading = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.3,
  );
  static const subheading = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static const body = TextStyle(fontSize: 13, color: AppColors.textPrimary);
  static const caption = TextStyle(fontSize: 11, color: AppColors.textSecondary);
  static const sectionLabel = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w700,
    color: AppColors.accent, letterSpacing: 1.2,
  );
}

class AppDecorations {
  static BoxDecoration card({Color? border}) => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: border ?? AppColors.border),
  );

  static BoxDecoration topBar() => const BoxDecoration(
    color: AppColors.bg,
    border: Border(bottom: BorderSide(color: AppColors.border)),
  );

  static BoxDecoration bottomNav() => const BoxDecoration(
    color: AppColors.bg,
    border: Border(top: BorderSide(color: AppColors.border)),
  );

  static InputDecoration formField(String label, {String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
    filled: true,
    fillColor: AppColors.surface2,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}
