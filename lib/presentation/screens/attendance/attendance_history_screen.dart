import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/mock_data.dart';
import '../../../shared/widgets/attendance_badge.dart';
import '../../../shared/widgets/empty_state_widget.dart';

/// Màn hình Lịch sử Điểm danh (Attendance History Screen)
/// Hỗ trợ tìm kiếm, lọc theo trạng thái và hiển thị Empty State khi không có dữ liệu
class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final _searchController = TextEditingController();
  AttendanceStatus? _selectedStatusFilter; // null = Tất cả
  DateTime? _selectedDate;
  bool _forceEmptyState =
      false; // Phím toggle để demo cho giảng viên xem Empty State

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AttendanceRecord> get _filteredRecords {
    if (_forceEmptyState) return [];

    final query = _searchController.text.trim().toLowerCase();
    return MockRepository.attendanceRecords.where((rec) {
      final matchesQuery =
          query.isEmpty ||
          rec.subjectName.toLowerCase().contains(query) ||
          rec.subjectCode.toLowerCase().contains(query);

      final matchesStatus =
          _selectedStatusFilter == null || rec.status == _selectedStatusFilter;

      final matchesDate =
          _selectedDate == null ||
          (rec.date.year == _selectedDate!.year &&
              rec.date.month == _selectedDate!.month &&
              rec.date.day == _selectedDate!.day);

      return matchesQuery && matchesStatus && matchesDate;
    }).toList();
  }

  void _showRecordDetailDialog(AttendanceRecord rec) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: rec.status.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(rec.status.icon, color: rec.status.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Chi tiết điểm danh',
                  style: AppTextStyles.headingMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Môn học:', rec.subjectName),
              _buildDetailRow('Mã học phần:', rec.subjectCode),
              _buildDetailRow('Phòng học:', rec.classroom),
              _buildDetailRow('Giảng viên:', rec.teacherName),
              _buildDetailRow(
                'Ngày:',
                '${rec.date.day}/${rec.date.month}/${rec.date.year}',
              ),
              _buildDetailRow('Thời gian:', rec.time),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 110,
                    child: Text(
                      'Trạng thái:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  AttendanceBadge(status: rec.status),
                ],
              ),
              if (rec.note != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Ghi chú:', rec.note!),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final records = _filteredRecords;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch Sử Điểm Danh'),
        actions: [
          IconButton(
            tooltip: _forceEmptyState
                ? 'Xem dữ liệu mẫu'
                : 'Mô phỏng trạng thái trống',
            icon: Icon(
              _forceEmptyState ? Icons.visibility_off : Icons.inbox_outlined,
              color: _forceEmptyState
                  ? AppColors.statusAbsent
                  : AppColors.primary,
            ),
            onPressed: () {
              setState(() {
                _forceEmptyState = !_forceEmptyState;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _forceEmptyState
                        ? 'Đang bật mô phỏng Giao diện Trống (Empty State)!'
                        : 'Đã hiển thị lại danh sách điểm danh!',
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Khung tìm kiếm & Bộ lọc
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            color: isDark ? AppColors.darkSurface : Colors.white,
            child: Column(
              children: [
                // Thanh tìm kiếm
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Tìm theo tên môn, mã học phần...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Thanh cuộn ngang các chip trạng thái
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        'Tất cả',
                        isSelected: _selectedStatusFilter == null,
                        onTap: () {
                          setState(() => _selectedStatusFilter = null);
                        },
                      ),
                      ...AttendanceStatus.values.map(
                        (status) => _buildFilterChip(
                          status.label,
                          isSelected: _selectedStatusFilter == status,
                          onTap: () {
                            setState(() => _selectedStatusFilter = status);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Danh sách bản ghi hoặc Empty State
          Expanded(
            child: records.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.history_toggle_off_rounded,
                    title: 'Không có dữ liệu điểm danh',
                    description: _forceEmptyState
                        ? 'Chế độ mô phỏng Empty State đang bật (nhấn icon hòm thư trên AppBar để tắt).'
                        : 'Không tìm thấy bản ghi nào phù hợp với bộ lọc hiện tại.',
                    actionText: _forceEmptyState
                        ? 'Hiển thị dữ liệu'
                        : 'Xóa bộ lọc',
                    onAction: () {
                      setState(() {
                        _forceEmptyState = false;
                        _searchController.clear();
                        _selectedStatusFilter = null;
                        _selectedDate = null;
                      });
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final rec = records[index];
                      return _buildRecordItem(rec, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primaryLight,
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildRecordItem(AttendanceRecord rec, bool isDark) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showRecordDetailDialog(rec),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      rec.subjectName,
                      style: AppTextStyles.headingSmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  AttendanceBadge(status: rec.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${rec.subjectCode} • ${rec.teacherName}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${rec.date.day.toString().padLeft(2, '0')}/${rec.date.month.toString().padLeft(2, '0')}/${rec.date.year}',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(rec.time, style: AppTextStyles.bodySmall),
                  const Spacer(),
                  Icon(
                    Icons.room_outlined,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(rec.classroom, style: AppTextStyles.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
