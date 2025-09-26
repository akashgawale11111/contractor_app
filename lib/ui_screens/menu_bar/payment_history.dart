import 'package:flutter/material.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  // 0 = This Week, 1 = This Month
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Payment History',
            style: TextStyle(fontFamily: 'Source Sans 3'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Total Paid',
                          style: TextStyle(
                            fontFamily: 'Source Sans 3',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '₹ 12000',
                          style: TextStyle(
                            fontFamily: 'Source Sans 3',
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Pending',
                          style: TextStyle(
                            fontFamily: 'Source Sans 3',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '₹ 3000',
                          style: TextStyle(
                            fontFamily: 'Source Sans 3',
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Days Worked',
                        style: TextStyle(
                          fontFamily: 'Source Sans 3',
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            // This Week Button
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 0;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        selectedIndex == 0
                                            ? Colors.yellow
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'This Week',
                                    style: TextStyle(
                                      fontFamily: 'Source Sans 3',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // This Month Button
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 1;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        selectedIndex == 1
                                            ? Colors.yellow
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'This Month',
                                    style: TextStyle(
                                      fontFamily: 'Source Sans 3',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Transaction History',
                        style: TextStyle(
                          fontFamily: 'Source Sans 3',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            '15 Aug',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '10 Aug',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '05 Aug',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Payment Mode Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Mode',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'UPI Transfer',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Cash',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Bank Transfer',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Hours Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hours',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            '8 hrs',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '8 hrs',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '9 hrs',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Amount Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            '₹ 3000',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹ 5000',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹ 2000',
                            style: TextStyle(
                              fontFamily: 'Source Sans 3',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
