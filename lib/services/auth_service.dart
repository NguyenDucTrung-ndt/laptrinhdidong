import 'package:flutter/foundation.dart';

import '../core/errors/auth_exception.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/mock_auth_repository.dart';

/// Dịch vụ Xác thực và Quản lý Trạng thái Phiên làm việc (Auth Service)
/// Đóng vai trò lớp trung gian phân tách toàn bộ logic nghiệp vụ (Business Logic) ra khỏi giao diện (UI)
class AuthService extends ChangeNotifier {
  // Singleton Pattern đảm bảo một phiên trạng thái đăng nhập duy nhất toàn ứng dụng
  static final AuthService instance = AuthService();

  final AuthRepository _repository;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthService({AuthRepository? repository})
    : _repository = repository ?? MockAuthRepository();

  // Getters cung cấp trạng thái cho UI
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isStudent => _currentUser?.isStudent ?? false;
  bool get isTeacher => _currentUser?.isTeacher ?? false;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Thực hiện đăng nhập
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.login(
        username: username,
        password: password,
      );
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Lỗi kết nối không xác định: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Thực hiện đăng ký tài khoản mới
  Future<bool> register({
    required String username,
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
    required String department,
    required String className,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.register(
        username: username,
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        role: role,
        department: department,
        className: className,
      );
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi khi đăng ký: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Đăng xuất tài khoản và xóa sạch dữ liệu phiên làm việc
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _repository.logout();
    _currentUser = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Xóa thông báo lỗi hiển thị trên giao diện
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
