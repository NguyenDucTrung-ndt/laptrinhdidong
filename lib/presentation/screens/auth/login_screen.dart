import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

/// Màn hình Đăng nhập tích hợp AuthService và phân quyền theo Vai trò
class LoginScreen extends StatefulWidget {
  final AuthService? authService;

  const LoginScreen({super.key, this.authService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AuthService _authService;
  UserRole _selectedRole = UserRole.student;
  bool _rememberMe = true;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService.instance;
    _fillDefaultAccount(UserRole.student);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDefaultAccount(UserRole role) {
    setState(() {
      _selectedRole = role;
      _localError = null;
      _authService.clearError();
      if (role == UserRole.student) {
        _usernameController.text = '21000123';
        _passwordController.text = '123456';
      } else {
        _usernameController.text = 'GV201509';
        _passwordController.text = '123456';
      }
    });
  }

  void _simulateWrongPassword() {
    setState(() {
      _passwordController.text = 'sai_mat_khau_123';
      _localError = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã điền mật khẩu sai để bạn thử nghiệm bắt lỗi! Nhấn Đăng nhập để xem.',
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() => _localError = null);
    _authService.clearError();

    if (!_formKey.currentState!.validate()) return;

    final success = await _authService.login(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      final user = _authService.currentUser!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Chào mừng ${user.fullName} (${user.role.displayName})!',
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.statusPresent,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Điều hướng dựa trên vai trò (Role-based Navigation)
      if (user.isStudent) {
        Navigator.pushReplacementNamed(context, AppConstants.routeStudentMain);
      } else {
        Navigator.pushReplacementNamed(context, AppConstants.routeTeacherMain);
      }
    } else {
      setState(() {
        _localError =
            _authService.errorMessage ?? 'Đăng nhập không thành công.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo & Tiêu đề
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Đăng Nhập',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Hệ thống điểm danh thông minh Smart Attendance',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Thanh chọn vai trò nhanh
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
                          child: _buildRoleButton(
                            role: UserRole.student,
                            icon: Icons.person_rounded,
                            isSelected: _selectedRole == UserRole.student,
                          ),
                        ),
                        Expanded(
                          child: _buildRoleButton(
                            role: UserRole.teacher,
                            icon: Icons.badge_rounded,
                            isSelected: _selectedRole == UserRole.teacher,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Lối tắt kiểm thử nhanh cho Giảng viên / Hội đồng
                  Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.school, size: 16),
                        label: const Text(
                          'Mẫu Sinh viên',
                          style: TextStyle(fontSize: 12),
                        ),
                        onPressed: () => _fillDefaultAccount(UserRole.student),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.person_pin, size: 16),
                        label: const Text(
                          'Mẫu Giảng viên',
                          style: TextStyle(fontSize: 12),
                        ),
                        onPressed: () => _fillDefaultAccount(UserRole.teacher),
                      ),
                      ActionChip(
                        avatar: const Icon(
                          Icons.error_outline,
                          size: 16,
                          color: AppColors.statusAbsent,
                        ),
                        label: const Text(
                          'Thử sai pass',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.statusAbsent,
                          ),
                        ),
                        onPressed: _simulateWrongPassword,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Thông báo lỗi nếu có
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
                            Icons.error_rounded,
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

                  // Form Fields
                  CustomTextField(
                    label: _selectedRole == UserRole.student
                        ? 'Mã số sinh viên (MSSV)'
                        : 'Mã số giảng viên',
                    hint: _selectedRole == UserRole.student
                        ? 'VD: 21000123'
                        : 'VD: GV201509',
                    controller: _usernameController,
                    prefixIcon: Icons.account_circle_outlined,
                    validator: (val) =>
                        Validators.validateCode(val, _selectedRole),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Mật khẩu',
                    hint: 'Nhập mật khẩu (tối thiểu 6 ký tự)',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 12),

                  // Ghi nhớ & Quên mật khẩu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (val) =>
                                  setState(() => _rememberMe = val ?? true),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ghi nhớ đăng nhập',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Chức năng cấp lại mật khẩu qua email sinh viên/giảng viên.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('Quên mật khẩu?'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Nút Đăng nhập
                  ListenableBuilder(
                    listenable: _authService,
                    builder: (context, _) {
                      return CustomButton(
                        text: 'Đăng nhập',
                        isLoading: _authService.isLoading,
                        onPressed: _handleLogin,
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Chuyển hướng Đăng ký
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chưa có tài khoản? ',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppConstants.routeRegister,
                          );
                        },
                        child: Text(
                          'Đăng ký ngay',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required UserRole role,
    required IconData icon,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _fillDefaultAccount(role),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
            ),
            const SizedBox(width: 8),
            Text(
              role.displayName,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
