import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Trạng thái điểm danh
enum AttendanceStatus {
  present(
    'Có mặt',
    AppColors.statusPresent,
    AppColors.statusPresentBg,
    Icons.check_circle_rounded,
  ),
  late(
    'Đi muộn',
    AppColors.statusLate,
    AppColors.statusLateBg,
    Icons.access_time_filled_rounded,
  ),
  absent(
    'Vắng mặt',
    AppColors.statusAbsent,
    AppColors.statusAbsentBg,
    Icons.cancel_rounded,
  ),
  excused(
    'Có phép',
    AppColors.statusExcused,
    AppColors.statusExcusedBg,
    Icons.info_rounded,
  );

  final String label;
  final Color color;
  final Color backgroundColor;
  final IconData icon;

  const AttendanceStatus(
    this.label,
    this.color,
    this.backgroundColor,
    this.icon,
  );
}

/// Bản ghi điểm danh của sinh viên
class AttendanceRecord {
  final String id;
  final String subjectName;
  final String subjectCode;
  final String classroom;
  final String teacherName;
  final DateTime date;
  final String time;
  final AttendanceStatus status;
  final String? note;

  const AttendanceRecord({
    required this.id,
    required this.subjectName,
    required this.subjectCode,
    required this.classroom,
    required this.teacherName,
    required this.date,
    required this.time,
    required this.status,
    this.note,
  });
}

/// Lớp học / Phiên điểm danh của giảng viên & sinh viên
class ClassSession {
  final String id;
  final String subjectName;
  final String subjectCode;
  final String classroom;
  final String timeRange;
  final int totalStudents;
  final int attendedStudents;
  final bool isActive;
  final String teacherName;

  const ClassSession({
    required this.id,
    required this.subjectName,
    required this.subjectCode,
    required this.classroom,
    required this.timeRange,
    required this.totalStudents,
    required this.attendedStudents,
    required this.isActive,
    required this.teacherName,
  });
}

/// Thông tin người dùng (Mock User)
class UserProfile {
  final String id;
  final String name;
  final String code; // MSSV hoặc Mã GV
  final String role; // 'Sinh viên' hoặc 'Giảng viên'
  final String email;
  final String phone;
  final String department;
  final String className;

  const UserProfile({
    required this.id,
    required this.name,
    required this.code,
    required this.role,
    required this.email,
    required this.phone,
    required this.department,
    required this.className,
  });
}

/// Dữ liệu mẫu (Mock Repository) cho mục đích hiển thị UI
class MockRepository {
  MockRepository._();

  static const UserProfile mockStudent = UserProfile(
    id: 'sv01',
    name: 'Nguyễn Đức Trung',
    code: '21000123',
    role: 'Sinh viên',
    email: 'trung.nd21000123@sinhvien.edu.vn',
    phone: '0987 654 321',
    department: 'Công nghệ thông tin',
    className: 'K66-CNTT-02',
  );

  static const UserProfile mockTeacher = UserProfile(
    id: 'gv01',
    name: 'TS. Trần Văn Hưng',
    code: 'GV201509',
    role: 'Giảng viên',
    email: 'hung.tv@giangvien.edu.vn',
    phone: '0912 345 678',
    department: 'Khoa Công nghệ thông tin',
    className: 'Bộ môn Hệ thống thông tin',
  );

  // Danh sách môn học hôm nay của sinh viên
  static final List<ClassSession> studentTodayClasses = [
    const ClassSession(
      id: 'c1',
      subjectName: 'Lập trình di động',
      subjectCode: 'IT4020',
      classroom: 'Phòng B1-302',
      timeRange: '07:30 - 09:50',
      totalStudents: 45,
      attendedStudents: 42,
      isActive: true, // Đang diễn ra điểm danh
      teacherName: 'TS. Trần Văn Hưng',
    ),
    const ClassSession(
      id: 'c2',
      subjectName: 'Kiến trúc phần mềm',
      subjectCode: 'IT4180',
      classroom: 'Phòng C2-401',
      timeRange: '10:00 - 11:45',
      totalStudents: 50,
      attendedStudents: 0,
      isActive: false,
      teacherName: 'PGS. TS. Lê Minh Tuấn',
    ),
    const ClassSession(
      id: 'c3',
      subjectName: 'Trí tuệ nhân tạo',
      subjectCode: 'IT4210',
      classroom: 'Phòng Lab 504',
      timeRange: '13:00 - 15:20',
      totalStudents: 40,
      attendedStudents: 0,
      isActive: false,
      teacherName: 'ThS. Hoàng Thị Lan',
    ),
  ];

  // Danh sách lớp giảng dạy của giảng viên
  static final List<ClassSession> teacherClasses = [
    const ClassSession(
      id: 'tc1',
      subjectName: 'Lập trình di động (Nhóm 1)',
      subjectCode: 'IT4020-01',
      classroom: 'Phòng B1-302',
      timeRange: '07:30 - 09:50',
      totalStudents: 45,
      attendedStudents: 42,
      isActive: true, // Phiên QR đang mở
      teacherName: 'TS. Trần Văn Hưng',
    ),
    const ClassSession(
      id: 'tc2',
      subjectName: 'Lập trình di động (Nhóm 2)',
      subjectCode: 'IT4020-02',
      classroom: 'Phòng B1-303',
      timeRange: '13:00 - 15:20',
      totalStudents: 48,
      attendedStudents: 0,
      isActive: false,
      teacherName: 'TS. Trần Văn Hưng',
    ),
    const ClassSession(
      id: 'tc3',
      subjectName: 'Phát triển ứng dụng Web',
      subjectCode: 'IT3080-01',
      classroom: 'Phòng A2-205',
      timeRange: '15:30 - 17:15',
      totalStudents: 60,
      attendedStudents: 0,
      isActive: false,
      teacherName: 'TS. Trần Văn Hưng',
    ),
  ];

  // Lịch sử điểm danh của sinh viên
  static final List<AttendanceRecord> attendanceRecords = [
    AttendanceRecord(
      id: 'rec1',
      subjectName: 'Lập trình di động',
      subjectCode: 'IT4020',
      classroom: 'B1-302',
      teacherName: 'TS. Trần Văn Hưng',
      date: DateTime.now(),
      time: '07:35:12',
      status: AttendanceStatus.present,
      note: 'Điểm danh qua mã QR thành công',
    ),
    AttendanceRecord(
      id: 'rec2',
      subjectName: 'Kiến trúc phần mềm',
      subjectCode: 'IT4180',
      classroom: 'C2-401',
      teacherName: 'PGS. TS. Lê Minh Tuấn',
      date: DateTime.now().subtract(const Duration(days: 1)),
      time: '10:02:40',
      status: AttendanceStatus.late,
      note: 'Đi muộn 12 phút',
    ),
    AttendanceRecord(
      id: 'rec3',
      subjectName: 'Trí tuệ nhân tạo',
      subjectCode: 'IT4210',
      classroom: 'Lab 504',
      teacherName: 'ThS. Hoàng Thị Lan',
      date: DateTime.now().subtract(const Duration(days: 2)),
      time: '13:05:00',
      status: AttendanceStatus.present,
      note: 'Điểm danh khuôn mặt đúng giờ',
    ),
    AttendanceRecord(
      id: 'rec4',
      subjectName: 'Cơ sở dữ liệu nâng cao',
      subjectCode: 'IT3290',
      classroom: 'D9-101',
      teacherName: 'TS. Phạm Quang Dũng',
      date: DateTime.now().subtract(const Duration(days: 3)),
      time: '--:--:--',
      status: AttendanceStatus.absent,
      note: 'Vắng không lý do',
    ),
    AttendanceRecord(
      id: 'rec5',
      subjectName: 'Mạng máy tính',
      subjectCode: 'IT3080',
      classroom: 'B1-102',
      teacherName: 'TS. Vũ Quốc Hoàng',
      date: DateTime.now().subtract(const Duration(days: 4)),
      time: '07:45:00',
      status: AttendanceStatus.excused,
      note: 'Có đơn xin phép nghỉ ốm',
    ),
    AttendanceRecord(
      id: 'rec6',
      subjectName: 'Lập trình di động',
      subjectCode: 'IT4020',
      classroom: 'B1-302',
      teacherName: 'TS. Trần Văn Hưng',
      date: DateTime.now().subtract(const Duration(days: 7)),
      time: '07:32:10',
      status: AttendanceStatus.present,
      note: 'Điểm danh đúng giờ',
    ),
  ];
}
