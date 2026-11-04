/// Lớp ngoại lệ cơ sở cho các lỗi xác thực
class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});

  @override
  String toString() => message;
}

/// Lỗi: Tài khoản không tồn tại
class UserNotFoundException extends AuthException {
  const UserNotFoundException([
    super.message = 'Tài khoản không tồn tại trong hệ thống. Vui lòng kiểm tra lại mã đăng nhập.',
  ]) : super(code: 'USER_NOT_FOUND');
}

/// Lỗi: Sai mật khẩu
class WrongPasswordException extends AuthException {
  const WrongPasswordException([
    super.message = 'Mật khẩu không chính xác. Vui lòng thử lại.',
  ]) : super(code: 'WRONG_PASSWORD');
}

/// Lỗi: Người dùng đã tồn tại khi đăng ký
class UserAlreadyExistsException extends AuthException {
  const UserAlreadyExistsException([
    super.message =
        'Mã người dùng hoặc Email này đã được đăng ký trong hệ thống.',
  ]) : super(code: 'USER_ALREADY_EXISTS');
}

/// Lỗi: Thông tin không hợp lệ
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([
    super.message = 'Thông tin đăng nhập hoặc đăng ký không hợp lệ.',
  ]) : super(code: 'INVALID_CREDENTIALS');
}
