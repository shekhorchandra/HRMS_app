import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'IntroPage.dart';
import 'NotificationPage.dart';
import 'attendance_screen.dart';
import 'login.dart';
import 'report_screen.dart';
import 'today_attendance_screen.dart';

// Widgets
import '../widgets/attendance_summary_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/working_hours_card.dart';

// Models
import '../models/user_model.dart';
import '../models/attendance_model.dart';
import '../models/working_hours_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late Timer _timer;
  String _currentTime = "";
  String _todayDate = "";

  // models
  late UserModel user;
  late AttendanceModel attendance;
  late WorkingHoursModel workingHours;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) => _updateTime());

    // Dummy model data (replace with API later)
    user = UserModel(
      name: "Mr. Shekhor Chandra Saha",
      designation: "Junior Flutter Developer",
      location: "522/B, North Shahjahanpur Dhaka-1217",
    );

    attendance = AttendanceModel(
      presentDays: 20,
      lateDays: 6,
      absentDays: 4,
      leaveDays: 4,
      sickLeaveDays: 2,
      casualLeaveDays: 3,
    );

    workingHours = WorkingHoursModel(
      totalHours: "38:24 hrs",
      overtimeHours: "01:20 hrs",
      chartData: [6, 8, 4, 7, 10, 0, 0],
      chartLabels: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
    );
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('hh : mm : a').format(now);
      _todayDate = DateFormat('dd MMM, yyyy').format(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // logout
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      // If no token found, just navigate to login
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final response = await http.post(
        Uri.parse('https://hrm.qbit-tech.com/api/emp-logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': token}),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      // Close loading indicator
      Navigator.pop(context);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Clear all stored data
        await prefs.clear();

        // Navigate to login page and remove all previous routes
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout successful'),
            backgroundColor: Color(0xFF0062CA),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Logout failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading indicator if exception occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _DashboardHomeScreen(
        currentTime: _currentTime,
        todayDate: _todayDate,
        user: user,
        attendance: attendance,
        workingHours: workingHours,
      ),
      AttendanceScreen(),
      ReportScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Confirm Exit'),
                content: const Text('Do you want to exit the app?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
        );

        if (shouldLogout == true) {
          await _logout(context);
          return false;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0062CA),
        drawer: _buildDrawer(),
        body: IndexedStack(index: _selectedIndex, children: screens),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF0062CA),),
            child: Text(
              'Welcome, ${user.name}!',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                ListTile(
                  leading: const Icon(Icons.upload_file),
                  title: const Text('Documents'),
                  onTap: () => Navigator.pushNamed(context, '/upload'),
                ),
                ListTile(
                  leading: Icon(Icons.campaign),
                  title: Text('Announcements'),
                  onTap: () => Navigator.pushNamed(context, '/announcement'),
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notice'),
                  onTap: () => Navigator.pushNamed(context, '/notice'),
                ),
                ListTile(
                  leading: Icon(Icons.check_circle),
                  title: Text('My Attendance'),
                  onTap: () => Navigator.pushNamed(context, '/attendence'),
                ),
                ListTile(
                  leading: Icon(Icons.event_note),
                  title: Text('Leave Application'),
                  onTap: () => Navigator.pushNamed(context, '/leave'),
                ),
                ListTile(
                  leading: Icon(Icons.mail_outline),
                  title: Text('Official Letter'),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Confirm Logout'),
                            content: const Text(
                              'Are you sure you want to logout?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                    );

                    if (shouldLogout == true) {
                      await _logout(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardHomeScreen extends StatefulWidget {
  final String currentTime;
  final String todayDate;
  final UserModel user;
  final AttendanceModel attendance;
  final WorkingHoursModel workingHours;

  const _DashboardHomeScreen({
    Key? key,
    required this.currentTime,
    required this.todayDate,
    required this.user,
    required this.attendance,
    required this.workingHours,
  }) : super(key: key);

  @override
  State<_DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<_DashboardHomeScreen> {
  String selectedMonth = 'January';
  bool isCheckedIn = false; // Track check-in state
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // top user info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Builder(
                  builder:
                      (context) => GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage('assets/images/img.png'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.user.designation,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NotificationPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          // today's attendance btn + date
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => TodaysAttendancePage(
                              status: "Late Login",
                              checkInTime: "09:45 AM",
                              checkOutTime: "06:00 PM",
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "Today's Attendance",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.todayDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // scrollable content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              // decoration: BoxDecoration(
              //   color: Colors.white.withOpacity(
              //     0.2,
              //   ), // semi-transparent glass
              //   borderRadius: const BorderRadius.vertical(
              //     top: Radius.circular(30),
              //   ),
              //   border: Border.all(
              //     color: Colors.white.withOpacity(0.1), // optional border
              //   ),
              // ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // starting time card
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.grey, // make card transparent for glass effect
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 2,
                            sigmaY: 2,
                          ), // soft blur
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFFFFFF,).withOpacity(0.6), // lighter purple
                                  const Color(0xFF308DCC,).withOpacity(0.6), // lighter blue
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topLeft,
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(
                                  0.2,
                                ), // optional soft border
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Starting Time",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.currentTime,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 18,
                                        color: Colors.white70,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.user.location,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // ✅ Check-In / Check-Out button
                                  if (!isCheckedIn)
                                    ElevatedButton(
                                      onPressed: () async {
                                        bool? confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Confirm Check-In"),
                                            content: const Text("Are you sure you want to Check-In?"),
                                            actionsAlignment: MainAxisAlignment.center, // center buttons
                                            actions: [
                                              SizedBox(
                                                width: 100, // same width for both buttons
                                                height: 40, // same height
                                                child: TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  child: const Text("Cancel"),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100,
                                                height: 40,
                                                child: TextButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.blue,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  child: const Text("Yes"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );


                                        if (confirmed == true) {
                                          setState(
                                            () => isCheckedIn = true,
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Checked In successfully!",
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(30),
                                        backgroundColor: Colors.green,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.login,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "Check-In",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: () async {
                                        bool? confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Confirm Check-Out"),
                                            content: const Text("Are you sure you want to Check-Out?"),
                                            actionsAlignment: MainAxisAlignment.center, // center buttons
                                            actions: [
                                              SizedBox(
                                                width: 100, // same width
                                                height: 40, // same height
                                                child: TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  child: const Text("Cancel"),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100,
                                                height: 40,
                                                child: TextButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.blue,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  child: const Text("Yes"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirmed == true) {
                                          setState(() => isCheckedIn = false);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Checked Out successfully!")),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(30),
                                        backgroundColor: Colors.red,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.logout, color: Colors.white, size: 28),
                                          SizedBox(height: 4),
                                          Text(
                                            "Check-Out",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // attendance summary card
                    Card(
                      color: Colors.transparent, // make the card itself transparent
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ), // subtle blur
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFFFFFF,).withOpacity(0.6), // lighter purple
                                  const Color(0xFF308DCC,).withOpacity(0.6), // lighter blue
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topLeft,
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(
                                  0.2,
                                ), // soft border for glass effect
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DefaultTextStyle(
                                style: const TextStyle(color: Colors.white),
                                child: AttendanceSummaryCard(
                                  title: "Total Attendance (Days)",
                                  present: widget.attendance.presentDays,
                                  latelogin: widget.attendance.lateDays,
                                  absent: widget.attendance.absentDays,
                                  leave: widget.attendance.leaveDays,
                                  sick_leave:
                                      widget.attendance.sickLeaveDays,
                                  casual_leave:
                                      widget.attendance.casualLeaveDays,
                                  monthDropdown: DropdownButton<String>(
                                    value: selectedMonth,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                    dropdownColor: Colors.white,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    underline: Container(
                                      height: 1,
                                      color: Colors.black,
                                    ),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          selectedMonth = newValue;
                                        });
                                      }
                                    },
                                    items:
                                        months.map<
                                          DropdownMenuItem<String>
                                        >((String month) {
                                          return DropdownMenuItem<String>(
                                            value: month,
                                            child: Text(month),
                                          );
                                        }).toList(),
                                  ),
                                  dateRange: '',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // working hours card
                    Card(color: Colors.transparent, // make card itself transparent
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ), // subtle blur
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFFFFFF,).withOpacity(0.6), // lighter purple
                                  const Color(0xFF308DCC,).withOpacity(0.6), // lighter blue
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topLeft,
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(
                                  0.2,
                                ), // optional light border
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  color: Colors.white,
                                ), // all text white
                                child: WorkingHoursCard(
                                  title: "Working Hours",
                                  totalHours:
                                      widget.workingHours.totalHours,
                                  overtimeHours:
                                      widget.workingHours.overtimeHours,
                                  showChart: true,
                                  chartData: widget.workingHours.chartData,
                                  chartLabels:
                                      widget.workingHours.chartLabels,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
