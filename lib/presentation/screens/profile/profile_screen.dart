import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/mock_data.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

/// Màn hình Hồ sơ cá nhân (Profile Screen)
class ProfileScreen extends StatefulWidget {
  final UserProfile user;

  const ProfileScreen({super.key, this.user = MockRepository.mockStudent});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  void _showEditProfileModal() {
    final phoneController = TextEditingController(text: _currentUser.phone);
    final emailController = TextEditingController(text: _currentUser.email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Cập nhật thông tin liên hệ',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Email liên hệ',
                  controller: emailController,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: 'Số điện thoại',
                  controller: phoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Lưu thay đổi',
                  onPressed: () {
                    setState(() {
                      _currentUser = UserProfile(
                        id: _currentUser.id,
                        name: _currentUser.name,
                        code: _currentUser.code,
                        role: _currentUser.role,
                        email: emailController.text,
                        phone: phoneController.text,
                        department: _currentUser.department,
                        className: _currentUser.className,
                      );
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Đã cập nhật thông tin cá nhân thành công!',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ Sơ Cá Nhân'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.routeSettings);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar và Tên
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _currentUser.name.split(' ').last.substring(0, 1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _currentUser.name,
              style: AppTextStyles.headingLarge.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _currentUser.role,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Thẻ chi tiết thông tin
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : AppColors.cardBorder,
                ),
              ),
              child: Column(
                children: [
                  _buildProfileTile(
                    icon: Icons.pin_outlined,
                    label: _currentUser.role == AppConstants.roleStudent
                        ? 'Mã số sinh viên'
                        : 'Mã số giảng viên',
                    value: _currentUser.code,
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildProfileTile(
                    icon: Icons.domain_outlined,
                    label: 'Khoa / Viện',
                    value: _currentUser.department,
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildProfileTile(
                    icon: Icons.groups_outlined,
                    label: _currentUser.role == AppConstants.roleStudent
                        ? 'Lớp sinh hoạt'
                        : 'Bộ môn chuyên ngành',
                    value: _currentUser.className,
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildProfileTile(
                    icon: Icons.email_outlined,
                    label: 'Email học vụ',
                    value: _currentUser.email,
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildProfileTile(
                    icon: Icons.phone_outlined,
                    label: 'Số điện thoại',
                    value: _currentUser.phone,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Nút Chỉnh sửa thông tin
            CustomButton(
              text: 'Chỉnh sửa thông tin liên hệ',
              type: ButtonType.outlined,
              icon: Icons.edit_outlined,
              onPressed: _showEditProfileModal,
            ),
            const SizedBox(height: 12),

            // Nút Cài đặt ứng dụng
            CustomButton(
              text: 'Cài đặt hệ thống',
              type: ButtonType.secondary,
              icon: Icons.tune_rounded,
              onPressed: () {
                Navigator.pushNamed(context, AppConstants.routeSettings);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
    );
  }
}
