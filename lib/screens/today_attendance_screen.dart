import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //

class TodaysAttendancePage extends StatelessWidget {

  final String status;
  final String checkInTime;
  final String checkOutTime;

  TodaysAttendancePage({
    Key? key,
    this.status = "Present",
    this.checkInTime = "09:15 AM",
    this.checkOutTime = "05:30 PM",
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case "present":
        return Colors.green;
      case "late":
      case "late login":
        return Colors.orange;
      case "absent":
        return Colors.red;
      case "on leave":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String todayDate = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Today's Attendance",style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        // backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todayDate,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.circle, color: _getStatusColor(), size: 16),
                const SizedBox(width: 8),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimeRow(Icons.login, "Check-in Time", checkInTime),
                    const Divider(height: 30),
                    _buildTimeRow(Icons.logout, "Check-out Time", checkOutTime),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(IconData icon, String label, String time) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const Spacer(),
        Text(
          time,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
