import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/auth_service.dart';
import '../../../shared/widgets/custom_button.dart';

/// Màn hình Cài đặt (Settings Screen)
/// Hỗ trợ chuyển đổi Dark Mode thời gian thực, bật/tắt thông báo, sinh trắc học và Đăng xuất
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = true;
  String _currentLanguage = 'Tiếng Việt';

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Chọn ngôn ngữ'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                setState(() => _currentLanguage = 'Tiếng Việt');
                Navigator.pop(ctx);
              },
              child: const Text('🇻🇳  Tiếng Việt'),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() => _currentLanguage = 'English');
                Navigator.pop(ctx);
              },
              child: const Text('🇺🇸  English'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Đổi mật khẩu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu hiện tại',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đổi mật khẩu thành công!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Cập nhật'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.qr_code_scanner,
          color: AppColors.primary,
          size: 32,
        ),
      ),
      children: const [
        Text(
          'Dự án Đồ án Lập trình thiết bị di động.\n'
          'Hệ thống điểm danh thông minh tích hợp QR Code động, chống gian lận và tối ưu trải nghiệm người dùng.\n\n'
          'Phát triển bởi: Nguyễn Đức Trung',
        ),
      ],
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản hiện tại không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.statusAbsent,
              ),
              onPressed: () async {
                Navigator.pop(ctx);
                await AuthService.instance.logout();
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppConstants.routeLogin,
                  (route) => false,
                );
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Cài Đặt')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section Giao diện
          _buildSectionHeader('Giao diện & Trải nghiệm', isDark),
          Card(
            child: Column(
              children: [
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: AppTheme.themeModeNotifier,
                  builder: (context, mode, child) {
                    final isDarkMode = mode == ThemeMode.dark;
                    return SwitchListTile(
                      secondary: Icon(
                        isDarkMode
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: AppColors.primary,
                      ),
                      title: const Text('Chế độ tối (Dark Mode)'),
                      subtitle: Text(isDarkMode ? 'Đang bật' : 'Đang tắt'),
                      value: isDarkMode,
                      onChanged: (val) {
                        AppTheme.toggleTheme();
                      },
                    );
                  },
                ),
                _buildDivider(isDark),
                ListTile(
                  leading: const Icon(
                    Icons.language_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text('Ngôn ngữ hiển thị'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentLanguage,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
                  onTap: _showLanguageDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section Thông báo & Bảo mật
          _buildSectionHeader('Bảo mật & Thông báo', isDark),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(
                    Icons.notifications_active_outlined,
                    color: AppColors.primary,
                  ),
                  title: const Text('Thông báo mở điểm danh'),
                  subtitle: const Text(
                    'Nhận nhắc nhở khi phiên điểm danh bắt đầu',
                  ),
                  value: _notificationsEnabled,
                  onChanged: (val) =>
                      setState(() => _notificationsEnabled = val),
                ),
                _buildDivider(isDark),
                SwitchListTile(
                  secondary: const Icon(
                    Icons.fingerprint_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text('Xác thực sinh trắc học'),
                  subtitle: const Text('Vân tay hoặc Face ID khi điểm danh'),
                  value: _biometricEnabled,
                  onChanged: (val) => setState(() => _biometricEnabled = val),
                ),
                _buildDivider(isDark),
                ListTile(
                  leading: const Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text('Đổi mật khẩu tài khoản'),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: _showChangePasswordDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section Giới thiệu
          _buildSectionHeader('Thông tin ứng dụng', isDark),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text('Thông tin đồ án Smart Attendance'),
                  subtitle: const Text(AppConstants.appVersion),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: _showAboutDialog,
                ),
                _buildDivider(isDark),
                ListTile(
                  leading: const Icon(
                    Icons.help_outline_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text('Hướng dẫn sử dụng'),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Tài liệu hướng dẫn điểm danh cho sinh viên và giảng viên.',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Nút Đăng xuất
          CustomButton(
            text: 'Đăng xuất tài khoản',
            icon: Icons.logout_rounded,
            type: ButtonType.outlined,
            customColor: AppColors.statusAbsent,
            onPressed: _handleLogout,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.labelMedium.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
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
