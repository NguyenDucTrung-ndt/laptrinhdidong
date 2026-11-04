import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../data/models/mock_data.dart';

/// Huy hiệu hiển thị trạng thái điểm danh
class AttendanceBadge extends StatelessWidget {
  final AttendanceStatus status;

  const AttendanceBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status.color.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: AppTextStyles.badgeText.copyWith(color: status.color),
          ),
        ],
      ),
    );
  }
}
