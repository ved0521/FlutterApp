import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LeaveRequestScreenState createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  String selectedYear = DateTime.now().year.toString();

  final List<Map<String, dynamic>> leaveRequests = [
    {'type': 'Sick Leave', 'status': 'Approved', 'date': DateTime(2025, 2, 12)},
    {
      'type': 'Casual Leave',
      'status': 'Pending',
      'date': DateTime(2024, 9, 18),
    },
    {
      'type': 'Annual Leave',
      'status': 'Rejected',
      'date': DateTime(2025, 4, 1),
    },
  ];

  final List<String> years = List.generate(
    5,
    (index) => (DateTime.now().year - index).toString(),
  );

  void _showLeaveInputBox() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Submit Leave Request',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextField(decoration: InputDecoration(labelText: 'Leave Type')),
                TextField(
                  decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Handle saving leave request
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredLeaves =
        leaveRequests
            .where(
              (leave) =>
                  DateFormat('yyyy').format(leave['date']) == selectedYear,
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          "Leave Request",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedYear,
              items:
                  years
                      .map(
                        (year) =>
                            DropdownMenuItem(value: year, child: Text(year)),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedYear = value);
                }
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child:
                  filteredLeaves.isEmpty
                      ? Center(
                        child: Text("No leave requests for $selectedYear"),
                      )
                      : ListView.builder(
                        itemCount: filteredLeaves.length,
                        itemBuilder: (context, index) {
                          final leave = filteredLeaves[index];
                          return Card(
                            child: ListTile(
                              title: Text(leave['type']),
                              subtitle: Text(
                                DateFormat(
                                  'MMM dd, yyyy',
                                ).format(leave['date']),
                              ),
                              trailing: Text(leave['status']),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _showLeaveInputBox,
        child: Icon(Icons.add),
      ),
    );
  }
}
