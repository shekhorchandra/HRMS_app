import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrm_system/screens/today_attendance_screen.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/bottom_nav_bar.dart';
import 'attendancelist_screen.dart'; // Custom bottom nav bar

class AttendanceScreen extends StatefulWidget {
   AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String todayDate = DateFormat('dd MMM, yyyy').format(DateTime.now());
  String checkInTime = "09 : 00 : AM";
  String currentLocation = "522/B, North Shahjahanpur Dhaka-1217";

  GoogleMapController? mapController;
  LatLng? _currentPosition;
  bool _isLoadingLocation = true;
  String _locationError = "";

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoadingLocation = false;
        _locationError = 'Location services are disabled. Please enable them.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoadingLocation = false;
          _locationError = 'Location permissions are denied.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoadingLocation = false;
        _locationError =
        'Location permissions are permanently denied, we cannot request permissions.';
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
        _locationError = "";
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
        _locationError = 'Failed to get location: $e';
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15.0),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/report');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Attendance",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodaysAttendancePage(
                            status: "Late Login",
                            checkInTime: "09:45 AM",
                            checkOutTime: "06:00 PM",
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text(
                      "Today's Attendance",
                      style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AttendanceListPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text(
                      "Attendance List",
                      style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),

                    ),
                  ),
                ),
                // const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),




      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                todayDate,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Card(
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
                            const Color(0xFFFFFFFF).withOpacity(0.6), // lighter white
                            const Color(0xFF308DCC).withOpacity(0.6), // lighter blue
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topLeft,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2), // soft border for glass effect
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                "Start Time",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                checkInTime,
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 18, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Text(
                                    currentLocation,
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _isLoadingLocation
                                ? Center(
                              child: Column(
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      _locationError.isNotEmpty
                                          ? _locationError
                                          : 'Getting your location...',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : _locationError.isNotEmpty
                                ? Center(
                              child: Text(
                                _locationError,
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                                : Container(
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GoogleMap(
                                  onMapCreated: _onMapCreated,
                                  initialCameraPosition: CameraPosition(
                                    target: _currentPosition ??
                                        const LatLng(23.777176, 90.399452),
                                    zoom: 15.0,
                                  ),
                                  markers: _currentPosition != null
                                      ? {
                                    Marker(
                                      markerId: const MarkerId(
                                          "current_location"),
                                      position: _currentPosition!,
                                    ),
                                  }
                                      : {},
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Check In Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  print("Check In button pressed!");
                                },
                                icon: const Icon(Icons.access_time, color: Colors.white),
                                label: const Text(
                                  "Check In",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Check Out Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  print("Check Out button pressed!");
                                },
                                icon: const Icon(Icons.logout_sharp, color: Colors.white),
                                label: const Text(
                                  "Check Out",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ),
            const SizedBox(height: 20),
            // Action Buttons
            Card(
              color: Colors.transparent, // make card itself transparent
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
                          const Color(0xFFFFFFFF).withOpacity(0.6),
                          const Color(0xFF308DCC).withOpacity(0.6),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topLeft,
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2), // soft border for glass effect
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(Icons.refresh, "Refresh", () {
                            _determinePosition();
                          }),
                          _buildActionButton(Icons.location_on_outlined, "Set Location", () {}),
                          _buildActionButton(Icons.qr_code_scanner, "Scan QR", () {}),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      // bottomNavigationBar: CustomBottomNavBar(
      //   selectedIndex: _selectedIndex,
      //   onItemTapped: _onItemTapped,
      // ),
    );
  }

  // Action Button Builder
  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30, color: Colors.black),
          onPressed: onPressed,
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black)),
      ],
    );
  }
}
