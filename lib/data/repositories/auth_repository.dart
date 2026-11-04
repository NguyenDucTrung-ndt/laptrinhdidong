import '../models/user_model.dart';

/// Interface trừu tượng cho tầng xác thực (Auth Repository Interface)
/// Tuân thủ Dependency Inversion Principle (chữ D trong SOLID)
/// Giúp dễ dàng tráo đổi giữa MockAuthRepository hiện tại và ApiAuthRepository trong tương lai
abstract class AuthRepository {
  /// Đăng nhập tài khoản với tên đăng nhập (MSSV/MGV) và mật khẩu
  Future<UserModel> login({required String username, required String password});

  /// Đăng ký tài khoản mới vào hệ thống
  Future<UserModel> register({
    required String username,
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
    required String department,
    required String className,
  });

  /// Đăng xuất tài khoản và hủy phiên làm việc
  Future<void> logout();

  /// Lấy thông tin người dùng đang đăng nhập trong phiên hiện tại
  Future<UserModel?> getCurrentUser();

  /// Kiểm tra xem mã định danh hoặc email đã tồn tại hay chưa
  Future<bool> checkUserExists(String username, String email);
}
