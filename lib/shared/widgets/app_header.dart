import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/user_model.dart';
import '../../services/auth_service.dart';

/// Header thanh điều hướng trên cùng hiển thị chào mừng, avatar và lối tắt cài đặt
class AppHeader extends StatelessWidget {
  final UserModel? user;
  final VoidCallback? onSettingsPressed;

  const AppHeader({super.key, this.user, this.onSettingsPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveUser =
        user ??
        AuthService.instance.currentUser ??
        UserModel(
          id: 'temp',
          username: '21000123',
          fullName: 'Nguyễn Đức Trung',
          email: 'trung.nd@sinhvien.edu.vn',
          phone: '0987654321',
          role: UserRole.student,
          department: 'Khoa Công nghệ thông tin',
          className: 'K66-CNTT-02',
          createdAt: DateTime.now(),
        );

    final initial = effectiveUser.fullName.isNotEmpty
        ? effectiveUser.fullName
              .trim()
              .split(' ')
              .last
              .substring(0, 1)
              .toUpperCase()
        : 'U';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Avatar với viền
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Thông tin chào mừng
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          effectiveUser.fullName,
                          style: AppTextStyles.headingSmall.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          effectiveUser.role.displayName,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${effectiveUser.username} • ${effectiveUser.className}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Nút cài đặt
            IconButton(
              onPressed:
                  onSettingsPressed ??
                  () {
                    Navigator.pushNamed(context, AppConstants.routeSettings);
                  },
              icon: Icon(
                Icons.settings_outlined,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
              tooltip: 'Cài đặt',
            ),
          ],
        ),
      ),
    );
  }
}
