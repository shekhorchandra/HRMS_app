import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hrm_system/screens/announcement.dart';
import 'package:hrm_system/screens/leave.dart';


import '../widgets/attendance_summary_card.dart';
import '../widgets/working_hours_card.dart'; // Custom bottom nav bar

class ReportScreen extends StatefulWidget {
   ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // Dummy Data //in real app usi api data
  String selectedDateRange = "5 Jan - 12 Jan";
  String totalWorkingHours = "38:24 hrs";
  String overtimeHours = "01:20 hrs";

  int presentDays = 20;
  int lateDays = 6;
  int absentDays = 4;
  int leaveDays = 4;
  int sick_leaveDays = 2;
  int casual_leaveDays = 3;

  // Chart data for working hours (in hours)
  List<double> workingHoursChartData = [
    6, 8, 4, 7, 10, 0, 0
  ]; // Sun, Mon, Tue, Wed, Thu, Fri, Sat
  List<String> workingHoursChartLabels = [
    "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
  ];

  String selectedMonth = 'January';
  List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Simulate selected bottom nav index
  // int _selectedIndex = 2; // 0 for Dashboard, 1 for Attendance, 2 for Report

  //navigation functions
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //     if (index == 0) {
  //       Navigator.pushReplacementNamed(context, '/dashboard');
  //     } else if (index == 1) {
  //       Navigator.pushReplacementNamed(context, '/attendance');
  //     }
  //     // If index is 2, stay on report
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: const Text(
          "Report",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyStatusCard(), // already updated
            ContactHRCard(),
            AnnouncementCard(),
            LeaveApplyCard(),
            const SizedBox(height: 20),

            // Working Hours Card
            Card(
              color: Colors.white, // white background
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: WorkingHoursCard(
                  title: "Working Hours",
                  totalHours: totalWorkingHours,
                  overtimeHours: overtimeHours,
                  showChart: true,
                  chartData: workingHoursChartData,
                  chartLabels: workingHoursChartLabels,
                  textColor: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Total Attendance (Days) Card
            Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AttendanceSummaryCard(
                  title: "Total Attendance (Days)",
                  present: presentDays,
                  latelogin: lateDays,
                  absent: absentDays,
                  leave: leaveDays,
                  sick_leave: sick_leaveDays,
                  casual_leave: casual_leaveDays,
                  monthDropdown: DropdownButton<String>(
                    value: selectedMonth,
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    underline: Container(height: 1, color: Colors.grey),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMonth = newValue!;
                      });
                    },
                    items: months.map<DropdownMenuItem<String>>((String month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                  ),
                  dateRange: '',
                  textColor: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

}

class MyStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white, // white background
      elevation: 5, // elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(Icons.access_time, color: Colors.green),
        title: const Text(
          "Today’s Status",
          style: TextStyle(color: Colors.black),
        ),
        subtitle: const Text(
          "Checked In at 09:02 AM",
          style: TextStyle(color: Colors.black),
        ),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}


class ContactHRCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(Icons.support_agent, color: Colors.blue),
        title: const Text(
          "Contact HR",
          style: TextStyle(color: Colors.black),
        ),
        subtitle: const Text(
          "Email or call HR department",
          style: TextStyle(color: Colors.black),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Opening HR Contact...")),
          );
        },
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(Icons.announcement, color: Colors.orange),
        title: const Text(
          "Announcements",
          style: TextStyle(color: Colors.black),
        ),
        subtitle: const Text(
          "View latest updates",
          style: TextStyle(color: Colors.black),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AnnouncementPage()),
          );
        },
      ),
    );
  }
}


class LeaveApplyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(Icons.calendar_month, color: Colors.redAccent),
        title: const Text(
          "Apply for Leave",
          style: TextStyle(color: Colors.black),
        ),
        subtitle: const Text(
          "Tap to submit a leave request",
          style: TextStyle(color: Colors.black),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LeaveMainPage()),
          );
        },
      ),
    );
  }
}
//
// class RequestCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         leading: const Icon(Icons.request_page, color: Colors.deepPurple),
//         title: const Text("My Requests"),
//         subtitle: const Text("View or create service requests"),
//         onTap: () {
//           Navigator.push(context, MaterialPageRoute(builder: (_) => LeaveMainPage()));
//         },
//       ),
//     );
//   }
// }

// Placeholder pages:
// class AnnouncementsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Announcements')),
//       body: const Center(child: Text('Announcements List')),
//     );
//   }
// }
//
//
// class RequestPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('My Requests')),
//       body: const Center(child: Text('Service Requests Page')),
//     );
//   }
// }




