import 'package:flutter/material.dart';
import 'package:sky_pad/Screens/LeaveDelete.dart';
import 'package:sky_pad/Screens/Leaveedit.dart';

import '../Data_service/Leave_api.dart';
import '../constant/url.dart';
import '../models/Constants.dart';

class LeaveRequestsPage extends StatefulWidget {
  @override
  _LeaveRequestsPageState createState() => _LeaveRequestsPageState();
}

class _LeaveRequestsPageState extends State<LeaveRequestsPage> {
  int casualCount = 0;
  int sickCount = 0;

  List<dynamic> leaveRequests = [];
  Map<String, dynamic> leaveCounts = {};
  @override
  void initState() {
    super.initState();
    _loadLeaveRequests();
    _fetchLeaveCounts();
    print(tokens);
  }

  final LeaveApiService apiService = LeaveApiService(LEAVES_VIEW, tokens);
  //**********         API function  (leave count)       *************//
  Future<void> _fetchLeaveCounts() async {
    final counts = await apiService.fetchLeaveCounts();
    setState(() {
      leaveCounts = counts;
    });
  }

  //**********         API function  (leave view)       *************//
  Future<void> _loadLeaveRequests() async {
    final leaveRequests = await apiService.loadLeaveRequests();
    setState(() {
      this.leaveRequests = leaveRequests;
    });
  }

  //**********         API function  (leave count)       *************//
  // Future<Map<String, dynamic>> fetchLeaveCounts() async {
  //   final apiUrl = ADD_LEAVE; // Replace with your API endpoint for leave counts
  //   final headers = {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $tokens',
  //   };
  //
  //   try {
  //     final response = await http.get(Uri.parse(apiUrl), headers: headers);
  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       return responseData; // Return the leave counts as a Map
  //     } else {
  //       print(
  //           'Error fetching leave counts. Status Code: ${response.statusCode}');
  //       print('Error Response Body: ${response.body}');
  //     }
  //   } catch (error) {
  //     print('Error connecting to the API: $error');
  //   }
  //
  //   return {'casual': 0, 'sick': 0}; // Return an empty Map in case of error
  // }
  //
  //**********         API function  (leave count)       *************//

  //**********         API function  (leave view)       *************//

  // Future<void> _loadLeaveRequests() async {
  //   final apiUrl = LEAVES_VIEW; // Replace with the actual API URL
  //   final headers = {
  //     'Accept': 'application/json',
  //     'Authorization':
  //         'Bearer $tokens', // Make sure you have 'tokens' defined somewhere
  //   };
  //
  //   try {
  //     final response = await http.get(Uri.parse(apiUrl), headers: headers);
  //     print(response.statusCode);
  //     // print(response.body['leaves']);
  //     // print(response.body[0]);
  //     if (response.statusCode == 200) {
  //       if (response.body.isNotEmpty) {
  //         final responseData = jsonDecode(response.body);
  //         setState(() {
  //           leaveRequests = responseData['leaves'];
  //         });
  //       } else {
  //         setState(() {
  //           leaveRequests = []; // Set an empty list to indicate no data
  //         });
  //         print('No leave requests available.');
  //       }
  //     } else {
  //       print('Error fetching leave requests: ${response.body}');
  //     }
  //   } catch (error) {
  //     print('Error connecting to the API: $error');
  //   }
  // }

  //**********         API function         *************//

  Widget _buildLeaveRequestsList() {
    if (leaveRequests.isEmpty) {
      return Center(
        child: Text("No leave requests found."),
      );
    } else {
      int count = leaveRequests.length;
      return Container(
        height: 800,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: count,
          itemBuilder: (context, index) {
            // Calculate casual and sick counts
            if (leaveRequests[index]['reason'] == 'Casual') {
              casualCount++;
            } else if (leaveRequests[index]['reason'] == 'Sick') {
              sickCount++;
            }

            String isApproved = leaveRequests[index]['is_approved'];
            Color cardColor;

            if (isApproved == 'Pending') {
              cardColor = Color(0xFFE8D3A3);
            } else if (isApproved == 'Approved') {
              cardColor = Color(0xFFE2E2B9);
            } else if (isApproved == 'Cancelled') {
              cardColor = Color(0xFFEABAACF);
            } else {
              cardColor = Colors.white;
            }

            return Container(
              width: double.infinity,
              child: Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                  // title: Text(isApproved),
                  title: Text(leaveRequests[index]['reason']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(leaveRequests[index]['reason']),

                      Text(leaveRequests[index]['date_from']),
                      Text(leaveRequests[index]['date_to']),
                    ],
                  ),
                  trailing: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width:
                              80, // Set a specific width for the trailing widget
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: isApproved == 'Pending'
                                ? Colors.orange
                                : isApproved == 'Approved'
                                    ? Colors.lightGreen
                                    : Colors.redAccent,
                          ),
                          child: Center(
                            child: Text(
                              isApproved,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          child: Container(
                            width:
                                40, // Set a specific width for the trailing widget
                            height: 30,
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                          ),
                          onTap: () {
                            _showEditLeaveDialog(context,
                                leaveDetails:
                                    leaveRequests[index]['id'].toString());
                          },
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        InkWell(
                          child: Container(
                            width:
                                40, // Set a specific width for the trailing widget
                            height: 30,
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          onTap: () {
                            // _showDeleteLeaveDialog(context);
                            _showDeleteLeaveDialog(
                                context, leaveRequests[index]['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  // // Calculate total count
  // int totalCount = casualCount + sickCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Requests'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularSection(
                  title: 'Sick',
                  value: sickCount.toString(),
                  color: Colors.red,
                  valueFontSize: 25.0,
                ),
                CircularSection(
                  title: 'Casual',
                  value: casualCount.toString(),
                  color: Colors.lightBlue,
                  valueFontSize: 25.0,
                ),
                CircularSection(
                  title: 'Total',
                  value: (int.parse(casualCount.toString() ?? '0') +
                          int.parse(sickCount.toString() ?? '0'))
                      .toString(),
                  color: Colors.orangeAccent,
                  valueFontSize: 25.0,
                ),
              ],
            ),
            // ToggleSwitch(
            //   minWidth: 100.0,
            //   cornerRadius: 20.0,
            //   activeBgColors: [
            //     [Colors.lightBlueAccent],
            //     [Colors.redAccent],
            //     [Colors.orangeAccent],
            //   ],
            //   activeFgColor: Colors.white,
            //   inactiveBgColor: Colors.white10,
            //   inactiveFgColor: Colors.white,
            //   initialLabelIndex: 1,
            //   totalSwitches: 3,
            //   labels: [
            //     'All',
            //     'Sick leave',
            //     'Casual leave',
            //   ],
            //   radiusStyle: true,
            //   onToggle: (index) {
            //     print('switched to: $index');
            //   },
            // ),

            // Leave Requests List
            _buildLeaveRequestsList(),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 56.0, // Set the desired width
        height: 56.0, // Set the desired height
        child: FloatingActionButton(
          elevation: 0.0,
          child: Icon(
            Icons.add,
            size: 30.0,
          ),
          backgroundColor: Color(0xFF0F5EF7),
          onPressed: () {
            Navigator.pushNamed(context, '/addleave');
          },
        ),
      ),
    );
  }
}

class CircularSection extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final double valueFontSize; // Add this property

  CircularSection({
    required this.title,
    required this.value,
    required this.color,
    required this.valueFontSize, // Initialize it in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.circle_rounded,
                color: color,
                size: 100,
                shadows: [BoxShadow(color: color)],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: valueFontSize, // Use the valueFontSize property
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _showEditLeaveDialog(BuildContext context,
    {required leaveDetails}) async {
  return showDialog(
    context: context,
    builder: (context) {
      // return EditLeaveDialog(
      //   leaveDetailsEndpoint: LEAVE_EDIT,
      //   leaveRequestId: null,
      // );

      return EditLeaveDialog(
        leaveDetailsEndpoint: leaveDetails,
      ); // Use the custom edit dialog
    },
  );
}

Future<void> _showDeleteLeaveDialog(BuildContext context, int leaveId) async {
  return showDialog(
    context: context,
    builder: (context) {
      return DeleteLeaveDialog(leaveId: leaveId); // Pass the leaveId
    },
  );
}
