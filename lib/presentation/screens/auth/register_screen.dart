import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

/// Màn hình Đăng ký tài khoản mới
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _classController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedRole = AppConstants.roleStudent;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _classController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký tài khoản thành công! Vui lòng đăng nhập.'),
          backgroundColor: AppColors.statusPresent,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng Ký Tài Khoản')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tạo tài khoản mới',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Chọn vai trò và điền thông tin để tham gia hệ thống',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // Chọn vai trò
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildRoleTab(
                          title: AppConstants.roleStudent,
                          isSelected: _selectedRole == AppConstants.roleStudent,
                          onTap: () => setState(
                            () => _selectedRole = AppConstants.roleStudent,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildRoleTab(
                          title: AppConstants.roleTeacher,
                          isSelected: _selectedRole == AppConstants.roleTeacher,
                          onTap: () => setState(
                            () => _selectedRole = AppConstants.roleTeacher,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Họ và tên
                CustomTextField(
                  label: 'Họ và tên',
                  hint: 'Nguyễn Văn A',
                  controller: _nameController,
                  prefixIcon: Icons.badge_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Vui lòng nhập họ tên'
                      : null,
                ),
                const SizedBox(height: 14),

                // Mã định danh
                CustomTextField(
                  label: _selectedRole == AppConstants.roleStudent
                      ? 'Mã số sinh viên (MSSV)'
                      : 'Mã số giảng viên',
                  hint: _selectedRole == AppConstants.roleStudent
                      ? '21000123'
                      : 'GV201509',
                  controller: _codeController,
                  prefixIcon: Icons.pin_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Vui lòng nhập mã'
                      : null,
                ),
                const SizedBox(height: 14),

                // Lớp / Bộ môn
                CustomTextField(
                  label: _selectedRole == AppConstants.roleStudent
                      ? 'Lớp sinh hoạt'
                      : 'Bộ môn / Khoa',
                  hint: _selectedRole == AppConstants.roleStudent
                      ? 'K66-CNTT-02'
                      : 'Khoa Công nghệ thông tin',
                  controller: _classController,
                  prefixIcon: Icons.domain_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Vui lòng nhập thông tin này'
                      : null,
                ),
                const SizedBox(height: 14),

                // Email
                CustomTextField(
                  label: 'Email trường cấp',
                  hint: 'example@edu.vn',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    if (!v.contains('@')) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Số điện thoại
                CustomTextField(
                  label: 'Số điện thoại',
                  hint: '0987 654 321',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (v) => (v == null || v.trim().length < 9)
                      ? 'Vui lòng nhập SĐT hợp lệ'
                      : null,
                ),
                const SizedBox(height: 14),

                // Mật khẩu
                CustomTextField(
                  label: 'Mật khẩu',
                  hint: 'Tối thiểu 6 ký tự',
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) => (v == null || v.length < 6)
                      ? 'Mật khẩu tối thiểu 6 ký tự'
                      : null,
                ),
                const SizedBox(height: 14),

                // Xác nhận mật khẩu
                CustomTextField(
                  label: 'Xác nhận mật khẩu',
                  hint: 'Nhập lại mật khẩu',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_reset_outlined,
                  validator: (v) {
                    if (v != _passwordController.text) {
                      return 'Mật khẩu xác nhận không khớp';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Nút Đăng ký
                CustomButton(
                  text: 'Hoàn tất đăng ký',
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 16),

                // Quay lại Đăng nhập
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đã có tài khoản? Đăng nhập ngay'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkSurface : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
