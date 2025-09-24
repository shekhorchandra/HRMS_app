import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'Checked In',
      'message': 'You checked in at 9:00 AM today.',
      'time': 'Today • 9:00 AM'
    },
    {
      'title': 'Leave Approved',
      'message': 'Your leave request for June 5 was approved.',
      'time': 'Yesterday • 3:45 PM'
    },
    {
      'title': 'New Project Assigned',
      'message': 'You have been assigned to the "HR Revamp" project.',
      'time': '2 days ago • 11:20 AM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white, // or any other color
            // fontSize: 20,        // optional
            fontWeight: FontWeight.bold, // optional
          ),
        ),
        foregroundColor: Colors.white,

        // backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read, color: Colors.white),
            onPressed: () {
              // Handle mark all as read
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.green),
              title: Text(notification['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(notification['message'] ?? ''),
              trailing: Text(
                notification['time'] ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
