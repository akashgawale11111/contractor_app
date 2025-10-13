import 'package:flutter/material.dart';

class AttendanceHistory extends StatelessWidget {
  const AttendanceHistory({super.key});

  // Sample attendance records
  final List<Map<String, String>> attendanceRecords = const [
    {'date': '15 Aug', 'punchIn': '08:00 AM', 'punchOut': '07:00 PM'},
    {'date': '16 Aug', 'punchIn': '08:15 AM', 'punchOut': '06:45 PM'},
    {'date': '17 Aug', 'punchIn': '09:00 AM', 'punchOut': '07:30 PM'},
    {'date': '18 Aug', 'punchIn': '08:05 AM', 'punchOut': '07:10 PM'},
    {'date': '19 Aug', 'punchIn': '08:05 AM', 'punchOut': '07:10 PM'},
    {'date': '20 Aug', 'punchIn': '08:05 AM', 'punchOut': '07:10 PM'},
    {'date': '21 Aug', 'punchIn': '08:05 AM', 'punchOut': '07:10 PM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance History',
          style: TextStyle(fontFamily: 'Source Sans 3'),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Padding(padding: EdgeInsets.all(8.0), child: Text('August')),
              ],
            ),

            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: attendanceRecords.length,
                itemBuilder: (context, index) {
                  final record = attendanceRecords[index];
                  final dateParts = record['date']!.split(' ');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        // Date Container
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFE990),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dateParts[0], // Day
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(dateParts[1]), // Month
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 15),

                        // Punch in/out Card
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withAlpha(76),
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text('Punch in'),
                                    SizedBox(height: 5),
                                    Text(
                                      record['punchIn']!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Punch out'),
                                    SizedBox(height: 5),
                                    Text(
                                      record['punchOut']!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
