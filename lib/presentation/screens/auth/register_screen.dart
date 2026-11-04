import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

/// Màn hình Đăng ký tài khoản mới kết nối với AuthService
class RegisterScreen extends StatefulWidget {
  final AuthService? authService;

  const RegisterScreen({super.key, this.authService});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController(
    text: 'Công nghệ thông tin',
  );
  final _classController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AuthService _authService;
  UserRole _selectedRole = UserRole.student;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService.instance;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _classController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() => _localError = null);
    _authService.clearError();

    if (!_formKey.currentState!.validate()) return;

    final success = await _authService.register(
      username: _codeController.text,
      fullName: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      role: _selectedRole,
      department: _departmentController.text,
      className: _classController.text,
    );

    if (!mounted) return;

    if (success) {
      final user = _authService.currentUser!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng ký thành công! Chào mừng ${user.fullName}.'),
          backgroundColor: AppColors.statusPresent,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Tự động chuyển thẳng vào Dashboard theo phân quyền
      if (user.isStudent) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppConstants.routeStudentMain,
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppConstants.routeTeacherMain,
          (route) => false,
        );
      }
    } else {
      setState(() {
        _localError = _authService.errorMessage ?? 'Đăng ký không thành công.';
      });
    }
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
                  'Chọn vai trò và điền đầy đủ thông tin để tham gia hệ thống',
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
                          role: UserRole.student,
                          isSelected: _selectedRole == UserRole.student,
                          onTap: () =>
                              setState(() => _selectedRole = UserRole.student),
                        ),
                      ),
                      Expanded(
                        child: _buildRoleTab(
                          role: UserRole.teacher,
                          isSelected: _selectedRole == UserRole.teacher,
                          onTap: () =>
                              setState(() => _selectedRole = UserRole.teacher),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Báo lỗi nếu có
                if (_localError != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.statusAbsentBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.statusAbsent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.statusAbsent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _localError!,
                            style: const TextStyle(
                              color: AppColors.statusAbsent,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Họ và tên
                CustomTextField(
                  label: 'Họ và tên',
                  hint: 'Nguyễn Văn A',
                  controller: _nameController,
                  prefixIcon: Icons.badge_outlined,
                  validator: (v) => Validators.validateRequired(v, 'Họ và tên'),
                ),
                const SizedBox(height: 14),

                // Mã định danh
                CustomTextField(
                  label: _selectedRole == UserRole.student
                      ? 'Mã số sinh viên (MSSV)'
                      : 'Mã số giảng viên',
                  hint: _selectedRole == UserRole.student
                      ? 'VD: 21000999'
                      : 'VD: GV202601',
                  controller: _codeController,
                  prefixIcon: Icons.pin_outlined,
                  validator: (v) => Validators.validateCode(v, _selectedRole),
                ),
                const SizedBox(height: 14),

                // Khoa / Viện
                CustomTextField(
                  label: 'Khoa / Viện đào tạo',
                  hint: 'VD: Công nghệ thông tin',
                  controller: _departmentController,
                  prefixIcon: Icons.account_balance_outlined,
                  validator: (v) =>
                      Validators.validateRequired(v, 'Khoa / Viện'),
                ),
                const SizedBox(height: 14),

                // Lớp sinh hoạt / Bộ môn
                CustomTextField(
                  label: _selectedRole == UserRole.student
                      ? 'Lớp sinh hoạt'
                      : 'Bộ môn trực thuộc',
                  hint: _selectedRole == UserRole.student
                      ? 'VD: K66-CNTT-01'
                      : 'VD: Bộ môn Hệ thống thông tin',
                  controller: _classController,
                  prefixIcon: Icons.groups_outlined,
                  validator: (v) => Validators.validateRequired(
                    v,
                    _selectedRole == UserRole.student
                        ? 'Lớp sinh hoạt'
                        : 'Bộ môn',
                  ),
                ),
                const SizedBox(height: 14),

                // Email
                CustomTextField(
                  label: 'Email trường cấp',
                  hint: 'example@sinhvien.edu.vn',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 14),

                // Số điện thoại
                CustomTextField(
                  label: 'Số điện thoại',
                  hint: '0987654321',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 14),

                // Mật khẩu
                CustomTextField(
                  label: 'Mật khẩu',
                  hint: 'Tối thiểu 6 ký tự',
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 14),

                // Xác nhận mật khẩu
                CustomTextField(
                  label: 'Xác nhận mật khẩu',
                  hint: 'Nhập lại mật khẩu vừa nhập',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_reset_outlined,
                  validator: (v) => Validators.validateConfirmPassword(
                    v,
                    _passwordController.text,
                  ),
                ),
                const SizedBox(height: 24),

                // Nút Đăng ký
                ListenableBuilder(
                  listenable: _authService,
                  builder: (context, _) {
                    return CustomButton(
                      text: 'Hoàn tất đăng ký',
                      isLoading: _authService.isLoading,
                      onPressed: _handleRegister,
                    );
                  },
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
    required UserRole role,
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
            role.displayName,
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
