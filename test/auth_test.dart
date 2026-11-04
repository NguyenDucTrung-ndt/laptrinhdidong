import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/errors/auth_exception.dart';
import 'package:flutter_application_1/core/utils/validators.dart';
import 'package:flutter_application_1/data/models/user_model.dart';
import 'package:flutter_application_1/data/repositories/mock_auth_repository.dart';
import 'package:flutter_application_1/services/auth_service.dart';

void main() {
  group('MockAuthRepository Tests', () {
    late MockAuthRepository repo;

    setUp(() {
      repo = MockAuthRepository();
    });

    test('Mật khẩu không được lưu dạng text thuần (Đã băm SHA-256 + Salt)', () {
      final hash = MockAuthRepository.hashPassword('123456');
      expect(hash, isNot('123456'));
      expect(hash.length, 64); // SHA-256 sinh chuỗi hex 64 ký tự
    });

    test('Đăng nhập thành công với tài khoản Sinh viên mẫu', () async {
      final user = await repo.login(username: '21000123', password: '123456');
      expect(user.username, '21000123');
      expect(user.role, UserRole.student);
      expect(user.isStudent, isTrue);
      expect(user.fullName, 'Nguyễn Đức Trung');
    });

    test('Đăng nhập thành công với tài khoản Giảng viên mẫu', () async {
      final user = await repo.login(username: 'GV201509', password: '123456');
      expect(user.username, 'GV201509');
      expect(user.role, UserRole.teacher);
      expect(user.isTeacher, isTrue);
      expect(user.fullName, 'TS. Trần Văn Hưng');
    });

    test('Ném lỗi WrongPasswordException khi sai mật khẩu', () async {
      expect(
        () => repo.login(username: '21000123', password: 'wrongpassword'),
        throwsA(isA<WrongPasswordException>()),
      );
    });

    test('Ném lỗi UserNotFoundException khi tài khoản không tồn tại', () async {
      expect(
        () => repo.login(username: '99999999', password: '123456'),
        throwsA(isA<UserNotFoundException>()),
      );
    });

    test('Đăng ký tài khoản mới thành công', () async {
      final newUser = await repo.register(
        username: '21000999',
        fullName: 'Lê Văn An',
        email: 'an.lv@sinhvien.edu.vn',
        phone: '0981112233',
        password: 'password123',
        role: UserRole.student,
        department: 'Khoa Công nghệ thông tin',
        className: 'K66-CNTT-01',
      );

      expect(newUser.username, '21000999');
      expect(newUser.fullName, 'Lê Văn An');

      // Thử đăng nhập lại với tài khoản vừa đăng ký
      final loggedIn = await repo.login(
        username: '21000999',
        password: 'password123',
      );
      expect(loggedIn.id, newUser.id);
    });

    test('Ném lỗi UserAlreadyExistsException khi đăng ký trùng mã', () async {
      expect(
        () => repo.register(
          username: '21000123', // Đã tồn tại
          fullName: 'Trùng Mã',
          email: 'unique@edu.vn',
          phone: '0988888888',
          password: 'password123',
          role: UserRole.student,
          department: 'CNTT',
          className: 'K66',
        ),
        throwsA(isA<UserAlreadyExistsException>()),
      );
    });

    test('Đăng xuất xóa bỏ người dùng hiện tại', () async {
      await repo.login(username: '21000123', password: '123456');
      expect(await repo.getCurrentUser(), isNotNull);

      await repo.logout();
      expect(await repo.getCurrentUser(), isNull);
    });
  });

  group('AuthService State Management Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService(repository: MockAuthRepository());
    });

    test('Trạng thái khởi tạo chưa đăng nhập', () {
      expect(authService.isAuthenticated, isFalse);
      expect(authService.currentUser, isNull);
      expect(authService.isLoading, isFalse);
      expect(authService.errorMessage, isNull);
    });

    test('Quản lý trạng thái khi đăng nhập thành công', () async {
      final success = await authService.login(
        username: '21000123',
        password: '123456',
      );
      expect(success, isTrue);
      expect(authService.isAuthenticated, isTrue);
      expect(authService.isStudent, isTrue);
      expect(authService.isTeacher, isFalse);
      expect(authService.currentUser?.fullName, 'Nguyễn Đức Trung');
    });

    test('Quản lý trạng thái khi đăng nhập thất bại do sai mật khẩu', () async {
      final success = await authService.login(
        username: '21000123',
        password: 'wrong',
      );
      expect(success, isFalse);
      expect(authService.isAuthenticated, isFalse);
      expect(authService.errorMessage, isNotNull);
      expect(authService.errorMessage, contains('Mật khẩu không chính xác'));
    });

    test('Đăng xuất thành công cập nhật trạng thái', () async {
      await authService.login(username: '21000123', password: '123456');
      expect(authService.isAuthenticated, isTrue);

      await authService.logout();
      expect(authService.isAuthenticated, isFalse);
      expect(authService.currentUser, isNull);
    });
  });

  group('Validators Tests', () {
    test('Validate Email chuẩn', () {
      expect(Validators.validateEmail('trung@edu.vn'), isNull);
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('not-an-email'), isNotNull);
    });

    test('Validate Password tối thiểu 6 ký tự', () {
      expect(Validators.validatePassword('123456'), isNull);
      expect(Validators.validatePassword('12345'), isNotNull);
      expect(Validators.validatePassword(''), isNotNull);
    });

    test('Validate Phone Việt Nam', () {
      expect(Validators.validatePhone('0987654321'), isNull);
      expect(Validators.validatePhone('0381234567'), isNull);
      expect(Validators.validatePhone('123456'), isNotNull);
    });

    test('Validate Mã định danh theo Role', () {
      expect(Validators.validateCode('21000123', UserRole.student), isNull);
      expect(Validators.validateCode('GV201509', UserRole.teacher), isNull);
      expect(Validators.validateCode('12', UserRole.student), isNotNull);
    });
  });
}
