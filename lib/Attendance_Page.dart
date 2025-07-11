// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'dart:async';
// ignore: unused_import
import 'Updateprofile_Page.dart';
// ignore: unused_import

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _HomeScreenState();
}

List<Map<String, DateTime>> attendanceRecords = [];

class _HomeScreenState extends State<AttendanceScreen> {
  String userName = '';
  String userEmail = '';
  String greeting = '';
  String currentTime = '';
  String currentDate = '';
  Timer? _timer;
  File? profileImage; // Add this

  DateTime? checkInTime;
  DateTime? checkOutTime;

  @override
  void initState() {
    super.initState();
    updateTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => updateTime(),
    );
  }

  void updateTime() {
    final now = DateTime.now();
    final hour = now.hour;
    setState(() {
      currentTime = DateFormat('hh:mm:ss a').format(now);
      currentDate = DateFormat('MMM dd, yyyy - EEEE').format(now);

      if (hour < 12) {
        greeting = 'Good Morning';
      } else if (hour < 17) {
        greeting = 'Good Afternoon';
      } else {
        greeting = 'Good Evening';
      }
    });
  }

  String getTotalHours() {
    if (checkInTime != null && checkOutTime != null) {
      final duration = checkOutTime!.difference(checkInTime!);
      return duration.toString().split('.').first.padLeft(8, "0");
    }
    return '--:--';
  }

  // ignore: unused_element
  Widget _infoBox(String label, String count, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      drawer: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: ListView(padding: EdgeInsets.zero),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green, // Set background to green
        title: const Text(
          "Attendance",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center, // this  is optional
        ),

        centerTitle: true, // this is actually center the titale
        elevation: 1,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Set icon color to white
        automaticallyImplyLeading: false, // Disables the default leading icon
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back icon
          onPressed:
              () => Navigator.pop(context), // Navigate back to Home screen
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hey ${userName.isNotEmpty ? userName : "your Name"}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$greeting! Mark your attendance',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),

            /// Check In / Check Out Button with Timer Inside
            GestureDetector(
              onTap: () async {
                final isLocationEnabled =
                    await Geolocator.isLocationServiceEnabled();
                if (!isLocationEnabled) {
                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text("Location Required"),
                          content: const Text(
                            "Please enable location to mark attendance.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await Geolocator.openLocationSettings();
                              },
                              child: const Text("Open Settings"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Cancel"),
                            ),
                          ],
                        ),
                  );
                  return;
                }
                if (checkInTime == null) {
                  checkInTime = DateTime.now();
                  attendanceRecords.add({
                    'checkIn': checkInTime!,
                    'checkOut': DateTime(2000), // Placeholder
                  });
                } else if (checkOutTime == null) {
                  checkOutTime = DateTime.now();
                  // Update the last record with check-out time
                  attendanceRecords[attendanceRecords.length - 1]['checkOut'] =
                      checkOutTime!;
                  Navigator.pop(context, attendanceRecords);
                  checkInTime = null;
                  checkOutTime = null;
                }
              },
              child: Container(
                width: 185,
                height: 185,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 48,
                      color:
                          checkInTime == null
                              ? Colors.green
                              : checkOutTime == null
                              ? Colors.red
                              : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      checkInTime == null
                          ? 'Check In'
                          : checkOutTime == null
                          ? 'Check Out'
                          : 'Reset',
                      style: TextStyle(
                        color:
                            checkInTime == null
                                ? Colors.green
                                : checkOutTime == null
                                ? Colors.red
                                : Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),
                    if (checkInTime != null && checkOutTime == null)
                      Text(
                        currentTime,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Dynamic History of Check In/Out Entries
            if (attendanceRecords.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today's Records:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                },
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey, width: 1),
                  top: BorderSide(color: Colors.grey, width: 1),
                  bottom: BorderSide(color: Colors.grey, width: 1),
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,

                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: Color(0xFFe1f5fe)),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'In Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Out Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Total Hr',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ...attendanceRecords.map((record) {
                    final checkIn = record['checkIn']!;
                    final checkOut = record['checkOut']!;
                    final duration = checkOut.difference(checkIn);
                    final totalHours = duration
                        .toString()
                        .split('.')
                        .first
                        .padLeft(8, "0");

                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateFormat('MMM dd, yyyy').format(checkIn),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(DateFormat('hh:mm a').format(checkIn)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            checkOut.year == 2000
                                ? '--'
                                : DateFormat('hh:mm a').format(checkOut),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            checkOut.year == 2000
                                ? '--:--'
                                : checkOut
                                    .difference(checkIn)
                                    .toString()
                                    .split('.')
                                    .first
                                    .padLeft(8, "0"),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
