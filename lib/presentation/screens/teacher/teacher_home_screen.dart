import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/mock_data.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/stat_card.dart';

/// Màn hình chính của Giảng viên (Teacher Home Screen)
class TeacherHomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToClasses;

  const TeacherHomeScreen({super.key, this.onNavigateToClasses});

  void _showGenerateQrModal(BuildContext context, ClassSession cls) {
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.statusPresent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PHIÊN ĐIỂM DANH ĐANG HOẠT ĐỘNG',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.statusPresent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                cls.subjectName,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingLarge.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              Text(
                '${cls.classroom} • ${cls.timeRange}',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Khung hiển thị mã QR động
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.qr_code_2_rounded,
                      size: 200,
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Mã tự làm mới sau: 15s',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tiến độ điểm danh
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Đã điểm danh',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${cls.attendedStudents}/${cls.totalStudents}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.statusPresent,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 28,
                      width: 1,
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                    Column(
                      children: [
                        const Text(
                          'Chưa có mặt',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${cls.totalStudents - cls.attendedStudents}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.statusAbsent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              CustomButton(
                text: 'Kết thúc phiên điểm danh',
                type: ButtonType.outlined,
                customColor: AppColors.statusAbsent,
                icon: Icons.stop_circle_outlined,
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Đã đóng phiên điểm danh và chốt danh sách!',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const teacher = MockRepository.mockTeacher;
    final classes = MockRepository.teacherClasses;

    return Scaffold(
      body: Column(
        children: [
          // Header
          const AppHeader(user: teacher),

          // Nội dung cuộn
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Tạo phiên điểm danh mới
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
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
                              child: const Text(
                                'QUẢN LÝ ĐIỂM DANH',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Icon(Icons.qr_code_2, color: Colors.white70),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Khởi tạo phiên điểm danh QR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tạo mã QR động chống gian lận cho lớp học hiện tại',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () =>
                              _showGenerateQrModal(context, classes.first),
                          icon: const Icon(
                            Icons.play_circle_fill_rounded,
                            size: 20,
                          ),
                          label: const Text('Mở mã QR lớp hiện tại'),
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

                  // Chỉ số thống kê của Giảng viên
                  Text(
                    'Tổng quan hôm nay',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Lớp hôm nay',
                          value: '3',
                          icon: Icons.class_outlined,
                          color: AppColors.primary,
                          subtitle: 'Tổng 153 SV',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          title: 'Đã điểm danh',
                          value: '42',
                          icon: Icons.how_to_reg_rounded,
                          color: AppColors.statusPresent,
                          subtitle: 'Lớp IT4020-01',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          title: 'Chuyên cần TB',
                          value: '93%',
                          icon: Icons.trending_up_rounded,
                          color: AppColors.secondary,
                          subtitle: 'Toàn học kỳ',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Danh sách lớp học đang phụ trách
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Danh sách lớp giảng dạy',
                        style: AppTextStyles.headingMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      TextButton.icon(
                        onPressed:
                            onNavigateToClasses ??
                            () {
                              Navigator.pushNamed(
                                context,
                                AppConstants.routeAttendanceHistory,
                              );
                            },
                        icon: const Icon(Icons.history_edu, size: 18),
                        label: const Text('Lịch sử'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ...classes.map(
                    (cls) => _buildTeacherClassCard(context, cls, isDark),
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

  Widget _buildTeacherClassCard(
    BuildContext context,
    ClassSession cls,
    bool isDark,
  ) {
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
                  child: const Text(
                    'Đang diễn ra',
                    style: TextStyle(
                      color: AppColors.statusPresent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${cls.subjectCode} • ${cls.classroom} • ${cls.timeRange}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          // Thanh tiến độ sĩ số
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: cls.totalStudents > 0
                  ? (cls.attendedStudents / cls.totalStudents)
                  : 0,
              backgroundColor: isDark
                  ? AppColors.darkSurfaceVariant
                  : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                cls.isActive ? AppColors.primary : AppColors.statusPresent,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Sĩ số: ${cls.attendedStudents}/${cls.totalStudents} SV',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              CustomButton(
                text: cls.isActive ? 'Hiện mã QR' : 'Mở điểm danh',
                type: cls.isActive ? ButtonType.primary : ButtonType.secondary,
                width: 140,
                height: 36,
                icon: Icons.qr_code,
                onPressed: () => _showGenerateQrModal(context, cls),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
