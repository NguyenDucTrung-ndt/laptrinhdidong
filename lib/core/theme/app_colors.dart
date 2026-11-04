import 'package:flutter/material.dart';

/// Bảng màu chuẩn của ứng dụng Smart Attendance
/// Tông màu chủ đạo: Xanh dương (Primary Blue) & Trắng (White)
class AppColors {
  AppColors._();

  // Primary Palette (Xanh dương hiện đại)
  static const Color primary = Color(0xFF1565C0); // Blue 800
  static const Color primaryLight = Color(0xFFE3F2FD); // Blue 50
  static const Color primaryDark = Color(0xFF0D47A1); // Blue 900
  static const Color accent = Color(0xFF0091EA); // Light Blue Accent

  // Secondary & Accents
  static const Color secondary = Color(0xFF0288D1);
  static const Color secondaryLight = Color(0xFFE1F5FE);

  // Surface & Background (Sạch sẽ, độ tương phản cao)
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Slate 100
  static const Color cardBorder = Color(0xFFE2E8F0); // Slate 200

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B); // Slate 800
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textTertiary = Color(0xFF94A3B8); // Slate 400
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status Colors (Trạng thái điểm danh)
  static const Color statusPresent = Color(0xFF16A34A); // Xanh lá - Có mặt
  static const Color statusPresentBg = Color(0xFFDCFCE7);

  static const Color statusLate = Color(0xFFD97706); // Cam - Đi muộn
  static const Color statusLateBg = Color(0xFFFEF3C7);

  static const Color statusAbsent = Color(0xFFDC2626); // Đỏ - Vắng mặt
  static const Color statusAbsentBg = Color(0xFFFEE2E2);

  static const Color statusExcused = Color(0xFF0284C7); // Xanh lam - Có phép
  static const Color statusExcusedBg = Color(0xFFE0F2FE);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceVariant = Color(0xFF334155); // Slate 700
  static const Color darkCardBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
}
