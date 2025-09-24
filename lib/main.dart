import 'package:flutter/material.dart';
import 'package:hrm_system/screens/UploadDocumentsPage.dart';
import 'package:hrm_system/screens/announcement.dart';
import 'package:hrm_system/screens/leave.dart';
import 'package:hrm_system/screens/my_attendance.dart';
import 'package:hrm_system/screens/notice_board.dart';
import 'package:hrm_system/screens/profilepage.dart';
import 'package:hrm_system/splash_screen.dart';
import 'screens/IntroPage.dart';
import 'screens/login.dart';
import 'screens/dashboard_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/report_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRM Employee Dashboard',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   brightness: Brightness.light,
      // ),
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        // brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAF7F3), // Light sky blue
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Colors.grey[700],
            fontFamily: "FontMain",
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0062CA), // Sky blue AppBar
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Fontappbar',
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),

      // Uncomment to support dark theme if needed
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   primarySwatch: Colors.teal,
      // ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      // Set initialRoute to '/intro' (since you have no '/' route defined)
      initialRoute: '/', // Splash screen is shown first

      routes: {
        '/': (context) => const SplashScreen(),
        // '/intro': (context) => const IntroPage(),
        '/login': (context) => const MyLogin(),
        '/dashboard': (context) => const DashboardScreen(),
        '/attendance': (context) =>  AttendanceScreen(),
        '/report': (context) => ReportScreen(),
        '/upload': (context) => const UploadDocumentsPage(),
        '/profile': (context) => const ProfilePage(),
        // '/status': (context) => const StatusPage(),
        // '/announcements': (context) => const AnnouncementsPage(),
        '/leave': (context) => const LeaveMainPage(),
        '/attendence': (context) => const AttendencePage(),
        '/notice': (context) => const NoticeBoardPage(),
        '/announcement': (context) => const AnnouncementPage(),
        // '/requests': (context) => const RequestsPage(),
        // '/contact_hr': (context) => const ContactHRPage(),
        // '/payslips': (context) => const PayslipsPage(),
        // '/settings': (context) => const SettingsPage(),
      },

      // Wrap every page with gradient background
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4B2A86), // deep purple
                Color(0xFF0062CA), // blue
              ],
              stops: [0.01, 1.0],
              begin: Alignment.bottomLeft,
              end: Alignment.topLeft,
            ),
          ),
          child: child,
        );
      },

    );
  }
}
