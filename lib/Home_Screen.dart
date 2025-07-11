// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'Attendance_Page.dart';
import 'ViewProfile_Page.dart';
import 'Leave_Page.dart';
import 'package:intl/intl.dart';
import 'Updateprofile_Page.dart';

import 'dart:async';
// ignore: unused_import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  String userEmail = '';
  String greeting = '';
  String currentTime = '';
  String currentDate = '';
  Timer? _timer;
  File? profileImage;
  String userDesignation = '';
  String reportingManager = '';
  String empCode = "";

  List<Map<String, DateTime>> attendanceRecords = [];

  Future<void> navigateToProfile(BuildContext context) async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(name: userName, email: userEmail),
      ),
    );

    if (updatedData != null) {
      setState(() {
        userName = updatedData['name'];
        userEmail = updatedData['email'];
        userDesignation = updatedData['designation'];
        empCode = updatedData['employeeCode'] ?? '';
        reportingManager = updatedData['reportingManager'] ?? '';
        profileImage = updatedData['image'];
      });
    }
  }

  Widget _profileInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                navigateToProfile(context);
              },
            ),
          ],
        ),
      ),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.green.shade700,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
          automaticallyImplyLeading: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Container(height: 80, color: Colors.green.shade700),
          Expanded(
            child: Column(
              children: [
                Transform.translate(
                  offset: const Offset(0, -80),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    profileImage != null
                                        ? FileImage(profileImage!)
                                        : const AssetImage(
                                              'assets/default_avatar.png',
                                            )
                                            as ImageProvider,
                                radius: 35,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName.isNotEmpty
                                          ? userName
                                          : 'Your Name',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      userDesignation.isNotEmpty
                                          ? userDesignation
                                          : "Your Designation",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _profileInfoRow(
                            "Emp Code:",
                            empCode.isNotEmpty ? empCode : 'Not set',
                          ),
                          const SizedBox(height: 12),
                          _profileInfoRow(
                            "Email:",
                            userEmail.isNotEmpty ? userEmail : 'Not set',
                          ),
                          const SizedBox(height: 12),
                          _profileInfoRow(
                            "Manager:",
                            reportingManager.isNotEmpty
                                ? reportingManager
                                : 'Not set',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),

                          crossAxisCount: 2,
                          padding: const EdgeInsets.all(16),
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          children: [
                            _dashboardButton(
                              "Attendance",
                              Icons.calendar_today,
                              Colors.green,
                              context,
                            ),
                            _dashboardButton(
                              "Leave Request",
                              Icons.event_busy,
                              Colors.blue,
                              context,
                            ),
                            _dashboardButton(
                              "Profil Screen",
                              Icons.tv,
                              Colors.pink,
                              context,
                            ),
                            _dashboardButton(
                              "Salary Slip",
                              Icons.account_balance_wallet,
                              Colors.amber,
                              context,
                            ),
                          ],
                        ),
                      ),
                      if (attendanceRecords.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 65,
                          child: Transform.translate(
                            offset: const Offset(
                              0,
                              -28,
                            ), // this was add to move box littele higher
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 29, 45, 59),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "In Time ",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        " ${DateFormat('hh:mm a').format(attendanceRecords.last['checkIn']!)}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Out Time",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                        ),
                                      ),

                                      Text(
                                        " ${DateFormat('hh:mm a').format(attendanceRecords.last['checkOut']!)}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateTo(String title, BuildContext context) async {
    if (title == "Attendance") {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AttendanceScreen()),
      );

      if (result != null && result is List<Map<String, DateTime>>) {
        setState(() {
          attendanceRecords = result;
        });
      }
    } else if (title == "Leave Request") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LeaveRequestScreen()),
      );
    } else if (title == "Profil Screen") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  Widget _dashboardButton(
    String title,
    IconData icon,
    Color bgColor,
    BuildContext context,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _navigateTo(title, context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.black),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
