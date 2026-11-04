/// Hằng số dùng chung trong ứng dụng Smart Attendance
class AppConstants {
  AppConstants._();

  static const String appName = 'Smart Attendance';
  static const String appTagline = 'Hệ thống điểm danh thông minh & chính xác';
  static const String appVersion = 'v1.0.0 (Giai đoạn 02)';

  // Key Roles
  static const String roleStudent = 'Sinh viên';
  static const String roleTeacher = 'Giảng viên';

  // Named Routes
  static const String routeSplash = '/';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeStudentMain = '/student-main';
  static const String routeTeacherMain = '/teacher-main';
  static const String routeSettings = '/settings';
  static const String routeAttendanceHistory = '/attendance-history';
}
