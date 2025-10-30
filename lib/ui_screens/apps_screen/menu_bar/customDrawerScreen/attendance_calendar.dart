import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:contractor_app/utils/shared_prefs.dart';

class CalendarAttendanceData {
  final String date;
  final String day;
  final String dayOfWeek;
  final String shortDay;
  final String status;
  final double hoursWorked;
  final String workType;
  final List<AttendanceEntry> entries;

  CalendarAttendanceData({
    required this.date,
    required this.day,
    required this.dayOfWeek,
    required this.shortDay,
    required this.status,
    required this.hoursWorked,
    required this.workType,
    required this.entries,
  });

  factory CalendarAttendanceData.fromJson(Map<String, dynamic> json) {
    return CalendarAttendanceData(
      date: json['date'],
      day: json['day'],
      dayOfWeek: json['day_of_week'],
      shortDay: json['short_day'],
      status: json['status'],
      hoursWorked: json['hours_worked']?.toDouble() ?? 0.0,
      workType: json['work_type'],
      entries: (json['entries'] as List?)
              ?.map((e) => AttendanceEntry.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AttendanceEntry {
  final int attendanceId;
  final int projectId;
  final String projectName;
  final String checkIn;
  final String checkOut;
  final String hoursWorked;

  AttendanceEntry({
    required this.attendanceId,
    required this.projectId,
    required this.projectName,
    required this.checkIn,
    required this.checkOut,
    required this.hoursWorked,
  });

  factory AttendanceEntry.fromJson(Map<String, dynamic> json) {
    return AttendanceEntry(
      attendanceId: json['attendance_id'],
      projectId: json['project_id'],
      projectName: json['project_name'],
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      hoursWorked: json['hours_worked'],
    );
  }
}

class AttendenceCal extends ConsumerStatefulWidget {
  const AttendenceCal({super.key});

  @override
  ConsumerState<AttendenceCal> createState() => _AttendenceCalState();
}

class _AttendenceCalState extends ConsumerState<AttendenceCal> {
  List<CalendarAttendanceData> attendanceData = [];
  bool isLoading = true;
  String monthName = '';
  late DateTime currentMonth;
  late int firstWeekday;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime.now();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = ref.read(authProvider);
      if (user == null) {
        print('Error: No user data available');
        return;
      }

      final userInfo = await SharedPrefs.getUserInfo();
      final userId = userInfo['userId'] ?? '';
      final userType = userInfo['userType'] ?? '';

      if (userId.isEmpty || userType.isEmpty) {
        print('Error: Missing user information');
        return;
      }

      final response = await http.get(
        Uri.parse(
            'https://admin.mmprecise.com/api/calendar-attendance?user_type=$userType&user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          final data = responseData['data'];
          monthName = data['month_name'];
          attendanceData = (data['calendar_attendance'] as List)
              .map((item) => CalendarAttendanceData.fromJson(item))
              .toList();

          // Set the first weekday based on the first day of the month
          if (attendanceData.isNotEmpty) {
            final firstDate = DateTime.parse(attendanceData[0].date);
            firstWeekday = firstDate.weekday;
          }
        }
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'half_day':
        return Colors.orange;
      case 'holiday':
        return const Color.fromARGB(255, 212, 36, 36);
      case 'overtime':
        return const Color.fromARGB(255, 35, 126, 196);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: const Text('Attendanc Calendar',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)))),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          monthName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(height: 20, width: 20, color: Colors.green),
                          Text('Full Day'),
                          SizedBox(width: 10),
                          Container(
                              height: 20,
                              width: 20,
                              color: const Color.fromARGB(255, 255, 153, 0)),
                          Text('Half Day'),
                          SizedBox(width: 10),
                          Container(
                              height: 20,
                              width: 20,
                              color: const Color.fromARGB(255, 212, 36, 36)),
                          Text('Holiday'),
                          SizedBox(width: 10),
                          Container(
                              height: 20,
                              width: 20,
                              color: const Color.fromARGB(255, 35, 126, 196)),
                          Text('Overtime'),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              monthName,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Weekday labels in grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 2,
                    ),
                    itemBuilder: (context, index) {
                      return Center(
                        child: Text(
                          weekDays[index],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 10),

                  // Date grid
                  Expanded(
                    child: GridView.builder(
                      itemCount: firstWeekday - 1 + attendanceData.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        if (index < firstWeekday - 1) {
                          return Container(); // Empty space for alignment
                        } else {
                          final attendance =
                              attendanceData[index - (firstWeekday - 1)];
                          return GestureDetector(
                            onTap: () {
                              if (attendance.entries.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                        'Attendance Details - ${attendance.date}'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Status: ${attendance.status}'),
                                          Text(
                                              'Hours Worked: ${attendance.hoursWorked}'),
                                          const SizedBox(height: 10),
                                          ...attendance.entries
                                              .map((entry) => Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'Project: ${entry.projectName}'),
                                                      Text(
                                                          'Check In: ${entry.checkIn}'),
                                                      Text(
                                                          'Check Out: ${entry.checkOut}'),
                                                      Text(
                                                          'Hours: ${entry.hoursWorked}'),
                                                      const Divider(),
                                                    ],
                                                  ))
                                              .toList(),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: getStatusColor(attendance.status),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    attendance.day,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (attendance.hoursWorked > 0)
                                    Text(
                                      '${attendance.hoursWorked}h',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
