/// Hai vai trò người dùng chính trong hệ thống Smart Attendance
enum UserRole {
  student('Sinh viên'),
  teacher('Giảng viên');

  final String displayName;
  const UserRole(this.displayName);

  static UserRole fromString(String role) {
    if (role.toLowerCase().contains('giảng viên') ||
        role.toLowerCase() == 'teacher') {
      return UserRole.teacher;
    }
    return UserRole.student;
  }
}

/// Model Người dùng (User Model)
/// Được thiết kế chuẩn hóa, sẵn sàng serialize JSON để tích hợp Backend API & SQL Server
class UserModel {
  final String id;
  final String username; // Mã số sinh viên (MSSV) hoặc Mã giảng viên (MGV)
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final String department; // Khoa / Viện
  final String className; // Lớp sinh hoạt hoặc Bộ môn
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    required this.className,
    this.avatarUrl,
    required this.createdAt,
    this.lastLoginAt,
  });

  bool get isStudent => role == UserRole.student;
  bool get isTeacher => role == UserRole.teacher;

  /// Sao chép đối tượng với một số trường thay đổi (Immutability Pattern)
  UserModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? email,
    String? phone,
    UserRole? role,
    String? department,
    String? className,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      department: department ?? this.department,
      className: className ?? this.className,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// Chuyển đổi từ JSON (khi nhận dữ liệu từ RESTful API / Database)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      role: UserRole.fromString(json['role'] as String? ?? 'student'),
      department: json['department'] as String? ?? '',
      className: json['className'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  /// Chuyển đổi sang JSON (khi gửi dữ liệu lên Backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role.name,
      'department': department,
      'className': className,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'UserModel(id: $id, username: $username, fullName: $fullName, role: ${role.displayName})';
}

