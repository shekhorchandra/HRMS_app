import 'package:flutter/material.dart';

class AttendencePage extends StatefulWidget {
  const AttendencePage({super.key});

  @override
  _AttendencePageState createState() => _AttendencePageState();
}

class _AttendencePageState extends State<AttendencePage> {
  TextEditingController _searchController = TextEditingController();

  // Sample static attendance data
  List<Map<String, String>> _attendanceData = List.generate(25, (index) => {
    'sl': '${index + 1}',
    'date': '2025-09-${(index % 30) + 1}',
    'checkIn': '09:0${index % 5} AM',
    'checkOut': '05:0${index % 5} PM',
    'status': index % 3 == 0 ? 'Present' : 'Absent',
    'late': index % 3 == 0 ? 'No' : 'Yes',
    'workingHour': '8h',
    'overtime': '${index % 2}h',
  });

  int _currentPage = 1;
  int _rowsPerPage = 10;

  List<Map<String, String>> get _paginatedData {
    int start = (_currentPage - 1) * _rowsPerPage;
    int end = start + _rowsPerPage;
    end = end > _attendanceData.length ? _attendanceData.length : end;
    return _attendanceData.sublist(start, end);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Absent':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Attendance',style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
        // backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search attendance records...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Attendance Cards List
            Expanded(
              child: ListView.builder(
                itemCount: _paginatedData.length,
                itemBuilder: (context, index) {
                  final record = _paginatedData[index];
                  return Card(
                    margin:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Left Column
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SL: ${record['sl']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text('Date: ${record['date']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text('Check In: ${record['checkIn']}'),
                                const SizedBox(height: 8),
                                Text('Check Out: ${record['checkOut']}'),
                              ],
                            ),
                            const SizedBox(width: 100),
                            // Right Column
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Status: '),
                                    Text(
                                      record['status']!,
                                      style: TextStyle(
                                          color:
                                          _statusColor(record['status']!),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('Late: ${record['late']}'),
                                const SizedBox(height: 8),
                                Text('Working Hour: ${record['workingHour']}'),
                                const SizedBox(height: 8),
                                Text('Overtime: ${record['overtime']}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Pagination Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _currentPage > 1
                      ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                      : null,
                  child: const Text('Previous'),
                  style: TextButton.styleFrom(
                    foregroundColor:
                    _currentPage > 1 ? Colors.blue : Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Page $_currentPage of ${(_attendanceData.length / _rowsPerPage).ceil()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: _currentPage <
                      (_attendanceData.length / _rowsPerPage).ceil()
                      ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                      : null,
                  child: const Text('Next'),
                  style: TextButton.styleFrom(
                    foregroundColor: _currentPage <
                        (_attendanceData.length / _rowsPerPage).ceil()
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
