import '../../data/models/user_model.dart';

/// Bộ kiểm tra tính hợp lệ dữ liệu đầu vào (Input Validators)
class Validators {
  Validators._();

  /// Kiểm tra trường bắt buộc
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    return null;
  }

  /// Kiểm tra định dạng Email chuẩn
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    final email = value.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Định dạng email không hợp lệ (VD: user@edu.vn)';
    }
    return null;
  }

  /// Kiểm tra mật khẩu (Tối thiểu 6 ký tự)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải chứa ít nhất 6 ký tự';
    }
    return null;
  }

  /// Kiểm tra khớp mật khẩu xác nhận
  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận lại mật khẩu';
    }
    if (value != originalPassword) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  /// Kiểm tra số điện thoại Việt Nam (10 chữ số)
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    final phone = value.trim().replaceAll(RegExp(r'\s+'), '');
    final phoneRegex = RegExp(r'^(0[3|5|7|8|9])[0-9]{8}$');
    if (!phoneRegex.hasMatch(phone)) {
      return 'Số điện thoại không hợp lệ (VD: 0987654321)';
    }
    return null;
  }

  /// Kiểm tra mã số sinh viên hoặc mã giảng viên
  static String? validateCode(String? value, UserRole role) {
    final roleName = role == UserRole.student
        ? 'Mã số sinh viên (MSSV)'
        : 'Mã số giảng viên';
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập $roleName';
    }
    if (value.trim().length < 4) {
      return '$roleName phải từ 4 ký tự trở lên';
    }
    return null;
  }
}
