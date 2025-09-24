import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnnouncementPage(),
    );
  }
}

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> _noticeData = List.generate(25, (index) => {
    'noticeFor': index % 2 == 0 ? 'All Employees' : 'Managers',
    'title': 'Announcement Title ${index + 1}',
    'details': '''
Dear all employees,

Please be informed that our HRM system will undergo scheduled maintenance starting on 15th September 2025 at 10:00 PM and is expected to continue until 16th September 2025 at 6:00 AM. This maintenance is part of our ongoing effort to improve system performance, enhance security protocols, and introduce several new features.

During this period, employees may experience temporary disruptions in accessing certain modules, including:
- Attendance tracking
- Leave applications
- Payroll details
''',
    'effectiveDate': '2025-09-${(index % 30) + 1}',
    'validTill': '2025-10-${(index % 30) + 1}',
  });

  int _currentPage = 1;
  int _rowsPerPage = 5;

  Map<int, TextEditingController> _feedbackControllers = {};
  Map<int, bool> _isExpanded = {};
  Map<int, List<Map<String, String>>> _comments = {};

  List<Map<String, String>> get _paginatedData {
    int start = (_currentPage - 1) * _rowsPerPage;
    int end = start + _rowsPerPage;
    end = end > _noticeData.length ? _noticeData.length : end;
    return _noticeData.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _noticeData.length; i++) {
      _feedbackControllers[i] = TextEditingController();
      _isExpanded[i] = false;
      _comments[i] = [];
    }
  }

  @override
  void dispose() {
    for (var controller in _feedbackControllers.values) {
      controller.dispose();
    }
    _searchController.dispose();
    super.dispose();
  }

  String _truncate(String text, [int length = 150]) {
    if (text.length <= length) return text;
    return '${text.substring(0, length)}...';
  }

  String _formatTime(DateTime dt) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Announcement',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
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
                hintText: 'Search notices...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),

            // Notice Cards List
            Expanded(
              child: ListView.builder(
                itemCount: _paginatedData.length,
                itemBuilder: (context, index) {
                  final noticeIndex = (_currentPage - 1) * _rowsPerPage + index;
                  final notice = _paginatedData[index];
                  final isExpanded = _isExpanded[noticeIndex]!;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: two columns
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // First Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Notice For: ${notice['noticeFor']}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Title: ${notice['title']}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),

                              // Vertical divider
                              const VerticalDivider(
                                color: Colors.grey,
                                width: 20,
                                thickness: 2,
                              ),

                              // Second Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Effective: ${notice['effectiveDate']}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Valid Till: ${notice['validTill']}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

// 🔥 Full width Details Section
                          Text(
                            isExpanded ? notice['details']! : _truncate(notice['details']!),
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),

                          if (notice['details']!.length > 200)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isExpanded[noticeIndex] = !isExpanded;
                                  });
                                },
                                child: Text(isExpanded ? 'Collapse' : 'View Details'),
                              ),
                            ),


                          const SizedBox(height: 12),

                          // Action: Feedback / Comments
                          TextField(
                            controller: _feedbackControllers[noticeIndex],
                            decoration: InputDecoration(
                              hintText: 'Add your comment...',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send, color: Colors.blue),
                                onPressed: () {
                                  final feedback = _feedbackControllers[noticeIndex]!.text;
                                  if (feedback.isNotEmpty) {
                                    setState(() {
                                      _comments[noticeIndex]!.add({
                                        'author': 'Employee',
                                        'text': feedback,
                                        'time': _formatTime(DateTime.now()),
                                      });
                                      _feedbackControllers[noticeIndex]!.clear();
                                    });
                                  }
                                },
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Show comments with admin reply option
                          if (_comments[noticeIndex]!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _comments[noticeIndex]!
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final commentIndex = entry.key;
                                final comment = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: comment['author'] == 'Employee'
                                              ? Colors.blue.shade50
                                              : Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${comment['author']} (${comment['time']}):',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(comment['text']!),
                                          ],
                                        ),
                                      ),
                                      if (comment['author'] == 'Employee')
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _comments[noticeIndex]!.insert(
                                                  commentIndex + 1,
                                                  {
                                                    'author': 'Admin',
                                                    'text': 'Admin Reply to comment "${comment['text']}"',
                                                    'time': _formatTime(DateTime.now()),
                                                  },
                                                );
                                              });
                                            },
                                            child: const Text(
                                              'Reply as Admin',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
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
                    'Page $_currentPage of ${(_noticeData.length / _rowsPerPage).ceil()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: _currentPage < (_noticeData.length / _rowsPerPage).ceil()
                      ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                      : null,
                  child: const Text('Next'),
                  style: TextButton.styleFrom(
                    foregroundColor: _currentPage < (_noticeData.length / _rowsPerPage).ceil()
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
