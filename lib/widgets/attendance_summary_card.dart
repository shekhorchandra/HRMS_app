import 'package:flutter/material.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final String title;
  final int present;
  final int latelogin;
  final int absent;
  final String dateRange;
  final int? leave;
  final int? sick_leave;
  final int? casual_leave;

  // Replaces dateRange
  final Widget? monthDropdown;

  const AttendanceSummaryCard({
    Key? key,
    required this.title,
    required this.present,
    required this.latelogin,
    required this.absent,
    required this.dateRange,
    this.leave,
    this.sick_leave,
    this.casual_leave,
    this.monthDropdown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: title + monthDropdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: monthDropdown ??
                  const Text(
                    'Select Month',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Status Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAttendanceStatus(present, "Present", Colors.green[700]!),
            _buildAttendanceStatus(latelogin, "Late", Colors.orange[700]!),
            _buildAttendanceStatus(absent, "Absent", Colors.red[700]!),

          ],
        ),
      ],
    );
  }

  Widget _buildAttendanceStatus(int count, String label, Color circleColor, {Color labelColor = Colors.black}) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: circleColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: circleColor, width: 1.5),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: circleColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: labelColor),
        ),
      ],
    );
  }

}
