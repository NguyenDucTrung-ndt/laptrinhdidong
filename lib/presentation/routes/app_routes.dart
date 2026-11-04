import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../screens/attendance/attendance_history_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/student/student_main_navigation.dart';
import '../screens/teacher/teacher_main_navigation.dart';

/// Quản lý tập trung toàn bộ Routes của ứng dụng Smart Attendance
class AppRoutes {
  AppRoutes._();

  static Map<String, WidgetBuilder> get routes => {
    AppConstants.routeSplash: (context) => const SplashScreen(),
    AppConstants.routeLogin: (context) => const LoginScreen(),
    AppConstants.routeRegister: (context) => const RegisterScreen(),
    AppConstants.routeStudentMain: (context) => const StudentMainNavigation(),
    AppConstants.routeTeacherMain: (context) => const TeacherMainNavigation(),
    AppConstants.routeSettings: (context) => const SettingsScreen(),
    AppConstants.routeAttendanceHistory: (context) =>
        const AttendanceHistoryScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    // Fallback nếu route không tìm thấy
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Không tìm thấy trang')),
        body: Center(child: Text('Trang ${settings.name} không tồn tại!')),
      ),
    );
  }
}
