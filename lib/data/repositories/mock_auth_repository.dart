import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../core/errors/auth_exception.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// Bản ghi tài khoản nội bộ (Lưu mật khẩu dạng HASH, TUYỆT ĐỐI KHÔNG LƯU TEXT THUẦN)
class _InternalAccount {
  final UserModel user;
  final String passwordHash;

  _InternalAccount({required this.user, required this.passwordHash});
}

/// Hiện thực hóa AuthRepository bằng Mock Data và thuật toán băm SHA-256 + Salt
/// Phục vụ kiểm thử toàn diện luồng nghiệp vụ xác thực trước khi kết nối API thật
class MockAuthRepository implements AuthRepository {
  // Salt bí mật giúp tăng cường tính an toàn khi băm mật khẩu
  static const String _salt = 'smart_attendance_secure_salt_2026';

  // "Cơ sở dữ liệu" mô phỏng trong bộ nhớ
  final Map<String, _InternalAccount> _usersDb = {};

  UserModel? _currentSessionUser;

  MockAuthRepository() {
    _initializeDefaultAccounts();
  }

  /// Băm mật khẩu sử dụng chuẩn mã hóa SHA-256 kết hợp Salt
  static String hashPassword(String password) {
    final bytes = utf8.encode(password + _salt);
    return sha256.convert(bytes).toString();
  }

  /// Khởi tạo tài khoản mẫu ban đầu cho Sinh viên và Giảng viên
  void _initializeDefaultAccounts() {
    // Tài khoản Sinh viên mẫu (Mật khẩu: 123456)
    final student = UserModel(
      id: 'usr_student_01',
      username: '21000123',
      fullName: 'Nguyễn Đức Trung',
      email: 'trung.nd21000123@sinhvien.edu.vn',
      phone: '0987654321',
      role: UserRole.student,
      department: 'Khoa Công nghệ thông tin',
      className: 'K66-CNTT-02',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    );
    _usersDb['21000123'] = _InternalAccount(
      user: student,
      passwordHash: hashPassword('123456'),
    );

    // Tài khoản Giảng viên mẫu (Mật khẩu: 123456)
    final teacher = UserModel(
      id: 'usr_teacher_01',
      username: 'GV201509',
      fullName: 'TS. Trần Văn Hưng',
      email: 'hung.tv@giangvien.edu.vn',
      phone: '0912345678',
      role: UserRole.teacher,
      department: 'Khoa Công nghệ thông tin',
      className: 'Bộ môn Hệ thống thông tin',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
    );
    _usersDb['GV201509'] = _InternalAccount(
      user: teacher,
      passwordHash: hashPassword('123456'),
    );
  }

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    // Mô phỏng độ trễ mạng như khi gọi REST API thật
    await Future.delayed(const Duration(milliseconds: 500));

    final normalizedUsername = username.trim().toUpperCase();

    // Tìm kiếm theo username hoặc email
    _InternalAccount? account = _usersDb[normalizedUsername];
    if (account == null) {
      for (final acc in _usersDb.values) {
        if (acc.user.email.toLowerCase() == username.trim().toLowerCase()) {
          account = acc;
          break;
        }
      }
    }

    if (account == null) {
      throw const UserNotFoundException();
    }

    // Kiểm tra mật khẩu bằng cách so khớp mã băm (Hash Comparison)
    final inputHash = hashPassword(password);
    if (account.passwordHash != inputHash) {
      throw const WrongPasswordException();
    }

    // Cập nhật thời điểm đăng nhập gần nhất
    final updatedUser = account.user.copyWith(lastLoginAt: DateTime.now());
    _usersDb[normalizedUsername] = _InternalAccount(
      user: updatedUser,
      passwordHash: account.passwordHash,
    );

    _currentSessionUser = updatedUser;
    return updatedUser;
  }

  @override
  Future<UserModel> register({
    required String username,
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
    required String department,
    required String className,
  }) async {
    // Mô phỏng độ trễ mạng
    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedUsername = username.trim().toUpperCase();
    final normalizedEmail = email.trim().toLowerCase();

    // Kiểm tra trùng lặp
    final isExists = await checkUserExists(normalizedUsername, normalizedEmail);
    if (isExists) {
      throw const UserAlreadyExistsException();
    }

    // Tạo người dùng mới
    final newUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      username: normalizedUsername,
      fullName: fullName.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
      role: role,
      department: department.trim(),
      className: className.trim(),
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    // Lưu trữ tài khoản với mật khẩu ĐÃ BĂM (Không lưu plain text)
    _usersDb[normalizedUsername] = _InternalAccount(
      user: newUser,
      passwordHash: hashPassword(password),
    );

    _currentSessionUser = newUser;
    return newUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentSessionUser = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentSessionUser;
  }

  @override
  Future<bool> checkUserExists(String username, String email) async {
    final normUser = username.trim().toUpperCase();
    final normEmail = email.trim().toLowerCase();

    if (_usersDb.containsKey(normUser)) return true;

    for (final acc in _usersDb.values) {
      if (acc.user.email.toLowerCase() == normEmail ||
          acc.user.username.toUpperCase() == normUser) {
        return true;
      }
    }
    return false;
  }
}
