import 'package:flutter/material.dart';

class AttendanceListPage extends StatelessWidget {
  // Sample attendance data: List of maps with date and status
  final List<Map<String, String>> attendanceData = [
    {"date": "2025-05-20", "status": "Present"},
    {"date": "2025-05-21", "status": "Late Login"},
    {"date": "2025-05-22", "status": "Absent"},
    {"date": "2025-05-23", "status": "Present"},
    {"date": "2025-05-24", "status": "Sick Leave"},
    {"date": "2025-05-25", "status": "Casual Leave"},
    {"date": "2025-05-26", "status": "Present"},
  ];

  // Status color for different attendance types
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "present":
        return Colors.green;
      case "late login":
        return Colors.orange;
      case "absent":
        return Colors.red;
      case "sick leave":
        return Colors.blue;
      case "casual leave":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Attendance List',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        // backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: attendanceData.length,
        separatorBuilder: (context, index) => const Divider(height: 16),
        itemBuilder: (context, index) {
          final dayData = attendanceData[index];
          final date = dayData["date"]!;
          final status = dayData["status"]!;
          final statusColor = _getStatusColor(status);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor,
              child: Text(
                date.split('-')[2], // show day number only
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              date,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(status),
            trailing: Icon(
              status.toLowerCase() == "present"
                  ? Icons.check_circle
                  : Icons.info_outline,
              color: statusColor,
            ),
          );
        },
      ),
    );
  }
}
