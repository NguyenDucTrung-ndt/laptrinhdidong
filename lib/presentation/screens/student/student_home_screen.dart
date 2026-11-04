import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/mock_data.dart';
import '../../../services/auth_service.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/attendance_badge.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/stat_card.dart';

/// Màn hình chính của Sinh viên (Student Home Screen)
class StudentHomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToHistory;

  const StudentHomeScreen({super.key, this.onNavigateToHistory});

  void _showQrScanDemoModal(BuildContext context, {String? subjectName}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Quét mã QR điểm danh',
                style: AppTextStyles.headingMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subjectName != null
                    ? 'Đang mở máy ảnh quét mã cho môn:\n$subjectName'
                    : 'Hướng camera vào mã QR hiển thị trên màn hình giảng viên để ghi nhận điểm danh.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              // Khung giả lập camera quét QR
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_2_rounded,
                      size: 140,
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    const Icon(
                      Icons.center_focus_strong_rounded,
                      size: 90,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Mô phỏng: Điểm danh thành công',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Ghi nhận điểm danh thành công lúc 07:35 AM!',
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.statusPresent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Đóng',
                type: ButtonType.text,
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = AuthService.instance.currentUser;
    final classes = MockRepository.studentTodayClasses;
    final recentRecords = MockRepository.attendanceRecords.take(3).toList();

    return Scaffold(
      body: Column(
        children: [
          // Header
          AppHeader(user: user),

          // Nội dung cuộn
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Điểm danh nhanh (Hero QR Card)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryDark, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.28),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.flash_on_rounded,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'ĐIỂM DANH NHANH',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'Hôm nay',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Sẵn sàng điểm danh tiết học?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Lớp Lập trình di động (B1-302) đang mở điểm danh',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _showQrScanDemoModal(
                            context,
                            subjectName: 'Lập trình di động',
                          ),
                          icon: const Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 20,
                          ),
                          label: const Text('Quét mã QR ngay'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryDark,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Chỉ số thống kê (Stat Cards Grid)
                  Text(
                    'Thống kê chuyên cần',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(
                        child: StatCard(
                          title: 'Tỉ lệ có mặt',
                          value: '92%',
                          icon: Icons.pie_chart_rounded,
                          color: AppColors.statusPresent,
                          subtitle: 'Đạt chuẩn',
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: StatCard(
                          title: 'Có mặt',
                          value: '23',
                          icon: Icons.check_circle_rounded,
                          color: AppColors.primary,
                          subtitle: 'Buổi học',
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: StatCard(
                          title: 'Vắng / Muộn',
                          value: '2',
                          icon: Icons.warning_amber_rounded,
                          color: AppColors.statusLate,
                          subtitle: '1 phép • 1 trễ',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Danh sách môn học hôm nay
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lịch học hôm nay',
                        style: AppTextStyles.headingMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${classes.length} môn',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ...classes.map(
                    (cls) => _buildClassCard(context, cls, isDark),
                  ),
                  const SizedBox(height: 20),

                  // Lịch sử điểm danh gần đây
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ghi nhận gần đây',
                        style: AppTextStyles.headingMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed:
                            onNavigateToHistory ??
                            () {
                              Navigator.pushNamed(
                                context,
                                AppConstants.routeAttendanceHistory,
                              );
                            },
                        child: const Text('Xem tất cả'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ...recentRecords.map(
                    (rec) => _buildRecentRecordCard(context, rec, isDark),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, ClassSession cls, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cls.isActive
              ? AppColors.primary
              : (isDark ? AppColors.darkCardBorder : AppColors.cardBorder),
          width: cls.isActive ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  cls.subjectName,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (cls.isActive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.statusPresentBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sensors_rounded,
                        size: 14,
                        color: AppColors.statusPresent,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Đang điểm danh',
                        style: TextStyle(
                          color: AppColors.statusPresent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${cls.subjectCode} • ${cls.teacherName}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(cls.timeRange, style: AppTextStyles.bodySmall),
              const SizedBox(width: 16),
              Icon(
                Icons.room_outlined,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(cls.classroom, style: AppTextStyles.bodySmall),
              const Spacer(),
              if (cls.isActive)
                TextButton.icon(
                  onPressed: () => _showQrScanDemoModal(
                    context,
                    subjectName: cls.subjectName,
                  ),
                  icon: const Icon(Icons.qr_code, size: 16),
                  label: const Text('Quét mã'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: AppColors.primary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRecordCard(
    BuildContext context,
    AttendanceRecord rec,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: rec.status.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(rec.status.icon, color: rec.status.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.subjectName,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${rec.time} • ${rec.classroom}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          AttendanceBadge(status: rec.status),
        ],
      ),
    );
  }
}
