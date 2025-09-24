import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LeaveMainPage(),
    );
  }
}

class LeaveMainPage extends StatelessWidget {
  const LeaveMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // two tabs
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Leave Management",style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
          // backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Selected tab style
            unselectedLabelStyle: const TextStyle(fontSize: 16), // Unselected tab style
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Leave History"),
              Tab(text: "New Leave"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LeaveListPage(),// placeholder for leave history
            LeaveApplicationPage(), // your leave form

          ],
        ),
      ),
    );
  }
}

// --- Leave Application Page (same as your previous code) ---
class LeaveApplicationPage extends StatefulWidget {
  const LeaveApplicationPage({Key? key}) : super(key: key);

  @override
  _LeaveApplicationPageState createState() => _LeaveApplicationPageState();
}

class _LeaveApplicationPageState extends State<LeaveApplicationPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _leaveType;
  List<PlatformFile> _selectedFiles = [];

  final List<DateTime> _holidays = [
    DateTime(2025, 12, 25),
    DateTime(2025, 1, 1),
  ];

  int get leaveDuration {
    if (_startDate != null && _endDate != null) {
      int days = 0;
      DateTime current = _startDate!;
      while (!current.isAfter(_endDate!)) {
        if (current.weekday != DateTime.friday &&
            current.weekday != DateTime.saturday &&
            !_holidays.any((h) =>
            h.year == current.year &&
                h.month == current.month &&
                h.day == current.day)) {
          days++;
        }
        current = current.add(const Duration(days: 1));
      }
      return days;
    }
    return 0;
  }

  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    final DateTime initialDate =
    isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      selectableDayPredicate: (date) {
        if (date.weekday == DateTime.friday || date.weekday == DateTime.saturday) {
          return false;
        }
        if (_holidays.any((h) =>
        h.year == date.year && h.month == date.month && h.day == date.day)) {
          return false;
        }
        return true;
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          if (_startDate != null && picked.isBefore(_startDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('End date cannot be before start date')),
            );
          } else {
            _endDate = picked;
          }
        }
      });
    }
  }

  Future<void> _pickDocuments() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _selectedFiles = result.files;
        });
      }
    } catch (e) {
      print("Error picking files: $e");
    }
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildDocumentsSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Documents (Attach Files - PDF/Image)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Center(
            child: InkWell(
              onTap: _pickDocuments,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.file_present, size: 32, color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (_selectedFiles.isNotEmpty)
            ..._selectedFiles.map((file) => ListTile(
              leading: file.extension == 'pdf'
                  ? const Icon(Icons.picture_as_pdf, color: Colors.red)
                  : const Icon(Icons.image, color: Colors.green),
              title: Text(file.name),
            )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leave Type
          _buildCard(
            child: DropdownButtonFormField<String>(
              value: _leaveType,
              items: const [
                DropdownMenuItem(value: 'Casual', child: Text('Casual')),
                DropdownMenuItem(value: 'Sick', child: Text('Sick')),
                DropdownMenuItem(value: 'Annual', child: Text('Annual')),
              ],
              onChanged: (value) => setState(() => _leaveType = value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                labelText: "Leave Type",
              ),
            ),
          ),

          const SizedBox(height: 8),
          // Start Date
          _buildCard(
            child: TextField(
              readOnly: true,
              controller: TextEditingController(
                  text: _startDate == null
                      ? ''
                      : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'),
              decoration: InputDecoration(
                labelText: "Start Date",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(context, true),
                ),
              ),
            ),
          ),
          // End Date
          _buildCard(
            child: TextField(
              readOnly: true,
              controller: TextEditingController(
                  text: _endDate == null
                      ? ''
                      : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'),
              decoration: InputDecoration(
                labelText: "End Date",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _pickDate(context, false),
                ),
              ),
            ),
          ),
          // Documents
          _buildDocumentsSection(),
          // Reason
          _buildCard(
            child: TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter reason for leave',
                border: OutlineInputBorder(),
                labelText: "Reason",
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Submit Button
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  leaveDuration > 0
                      ? 'Apply for $leaveDuration Days Leave'
                      : 'Apply for Leave',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Leave List Tab ---

class LeaveListPage extends StatefulWidget {
  const LeaveListPage({super.key});

  @override
  _LeaveListPageState createState() => _LeaveListPageState();
}

class _LeaveListPageState extends State<LeaveListPage> {
  TextEditingController _searchController = TextEditingController();

  // Sample static leave data
  List<Map<String, String>> _leaveData = List.generate(25, (index) => {
    'sl': '${index + 1}',
    'leaveType': index % 3 == 0
        ? 'Sick'
        : index % 3 == 1
        ? 'Annual'
        : 'Casual',
    'days': '${(index % 5) + 1}',
    'appliedOn': '2025-09-${(index % 30) + 1}',
    'status': index % 3 == 0 ? 'Approved' : 'Pending',
    'approvedBy': index % 3 == 0 ? 'Manager A' : '-',
  });

  int _currentPage = 1;
  int _rowsPerPage = 10;

  List<Map<String, String>> get _paginatedData {
    int start = (_currentPage - 1) * _rowsPerPage;
    int end = start + _rowsPerPage;
    end = end > _leaveData.length ? _leaveData.length : end;
    return _leaveData.sublist(start, end);
  }

  Color _leaveTypeColor(String type) {
    switch (type) {
      case 'Sick':
        return Colors.red;
      case 'Annual':
        return Colors.yellow[800]!; // darker yellow
      case 'Casual':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search leave records...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),

          // Leave Cards List
          Expanded(
            child: ListView.builder(
              itemCount: _paginatedData.length,
              itemBuilder: (context, index) {
                final leave = _paginatedData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Left column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SL: ${leave['sl']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Leave Type: '),
                                  Text(
                                    leave['leaveType']!,
                                    style: TextStyle(
                                      color: _leaveTypeColor(leave['leaveType']!),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Number of Days: ${leave['days']}'),
                            ],
                          ),
                        ),
                        // Right column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Applied On: ${leave['appliedOn']}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Status: '),
                                  Text(
                                    leave['status']!,
                                    style: TextStyle(
                                      color: _statusColor(leave['status']!),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Approved By: ${leave['approvedBy']}'),
                            ],
                          ),
                        ),
                      ],
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
              foregroundColor: _currentPage > 1 ? Colors.blue : Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Page $_currentPage of ${(_leaveData.length / _rowsPerPage).ceil()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: _currentPage < (_leaveData.length / _rowsPerPage).ceil()
                ? () {
              setState(() {
                _currentPage++;
              });
            }
                : null,
            child: const Text('Next'),
            style: TextButton.styleFrom(
              foregroundColor: _currentPage < (_leaveData.length / _rowsPerPage).ceil()
                  ? Colors.blue
                  : Colors.grey,
            ),
          ),
        ],
      ),

      ],
      ),
    );
  }
}



