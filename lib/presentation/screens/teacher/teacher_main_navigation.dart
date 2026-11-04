import 'package:flutter/material.dart';

import '../../../data/models/mock_data.dart';
import '../attendance/attendance_history_screen.dart';
import '../profile/profile_screen.dart';
import 'teacher_home_screen.dart';

/// Khung điều hướng chính của Giảng viên kèm Bottom Navigation Bar
class TeacherMainNavigation extends StatefulWidget {
  const TeacherMainNavigation({super.key});

  @override
  State<TeacherMainNavigation> createState() => _TeacherMainNavigationState();
}

class _TeacherMainNavigationState extends State<TeacherMainNavigation> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      TeacherHomeScreen(onNavigateToClasses: () => _onTabTapped(1)),
      const AttendanceHistoryScreen(),
      const ProfileScreen(user: MockRepository.mockTeacher),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Tổng quan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check_outlined),
            activeIcon: Icon(Icons.fact_check_rounded),
            label: 'Điểm danh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle_rounded),
            label: 'Hồ sơ GV',
          ),
        ],
      ),
    );
  }
}
