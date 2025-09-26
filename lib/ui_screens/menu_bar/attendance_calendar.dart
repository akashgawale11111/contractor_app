import 'package:flutter/material.dart';

class AttendenceCal extends StatefulWidget {
  const AttendenceCal({super.key});

  @override
  State<AttendenceCal> createState() => _AttendenceCalState();
}

class _AttendenceCalState extends State<AttendenceCal> {
  final int year = 2025;
  final int month = 8; // August
  late List<DateTime> monthDays;
  late int firstWeekday;

  @override
  void initState() {
    super.initState();
    int daysInMonth = DateTime(year, month + 1, 0).day;
    monthDays = List.generate(daysInMonth, (index) {
      return DateTime(year, month, index + 1);
    });
    firstWeekday = DateTime(year, month, 1).weekday; // 1=Mon, 7=Sun
  }

  Color getDateColor(DateTime date) {
    if (date.day == 5) {
      return Colors.red;
    } else if (date.day == 7 || date.day == 29) {
      return Colors.yellow;
    } else if (date.weekday == 6 || date.weekday == 7) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Attendance'))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'August',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    Container(height: 20, width: 20, color: Colors.yellow),
                    Text('Half Day'),
                    SizedBox(width: 10),
                    Container(height: 20, width: 20, color: Colors.blue),
                    Text('Holiday'),
                    SizedBox(width: 10),
                    Container(height: 20, width: 20, color: Colors.red),
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
                        'August',
                        style: TextStyle(color: Colors.white),
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
                itemCount: firstWeekday - 1 + monthDays.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  if (index < firstWeekday - 1) {
                    return Container(); // Empty space for alignment
                  } else {
                    DateTime date = monthDays[index - (firstWeekday - 1)];
                    return Container(
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: getDateColor(date),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(color: Colors.white),
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
