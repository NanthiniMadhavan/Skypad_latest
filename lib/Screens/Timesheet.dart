import 'package:flutter/material.dart';

import '../Data_service/Timesheet_api.dart';
import '../models/Constants.dart';
import 'EditTime.dart';
import 'Timedelete.dart';

class Timesheetview extends StatefulWidget {
  @override
  _TimesheetviewState createState() => _TimesheetviewState();
}

class _TimesheetviewState extends State<Timesheetview> {
  List<dynamic> timesheet = [];
  DateTime _selectedDay = DateTime.now();
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState() {
    _loadTimesheet();
    print(tokens);
    super.initState();
    _selectedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(Duration(days: 7)); // 7 days ago
    _lastDay = DateTime.now();
  }

  Future<void> _loadTimesheet() async {
    final timesheetData = await TimesheetAPI.fetchTimesheet();
    setState(() {
      timesheet = timesheetData;
    });

    //**********         API function         *************//

    // final apiUrl = TIMESHEET_VIEW; // Replace with your API endpoint
    // final headers = {
    //   'Accept': 'application/json',
    //   'Authorization':
    //       'Bearer $tokens', // Replace with your authentication logic
    // };
    //
    // try {
    //   final response = await http.get(Uri.parse(apiUrl), headers: headers);
    //
    //   if (response.statusCode == 200) {
    //     final responseData = jsonDecode(response.body);
    //     setState(() {
    //       timesheet = responseData;
    //       // Adjust the key as per your API response structure
    //     });
    //   } else {
    //     print('Error fetching Time sheet: ${response.body}');
    //   }
    // } catch (error) {
    //   print('Error connecting to the API: $error');
    // }

    //**********         API function         *************//
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TimeSheet'),
      ),
      body: Column(
        children: [
          // *****   calender UI ***** //    (if needed)

          // Container(
          //   margin: const EdgeInsets.only(top: 20.0, left: 20.0),
          //   child: TableCalendar(
          //     firstDay: _firstDay,
          //     lastDay: _lastDay,
          //     focusedDay: _selectedDay,
          //     calendarFormat: CalendarFormat.week,
          //     onDaySelected: (selectedDay, focusedDay) {
          //       setState(() {
          //         _selectedDay = selectedDay;
          //       });
          //     },
          //     headerStyle: HeaderStyle(
          //       titleCentered: true,
          //       titleTextStyle: TextStyle(color: Colors.white, fontSize: 15),
          //       formatButtonTextStyle:
          //           TextStyle(color: Colors.white, fontSize: 15),
          //       formatButtonDecoration: BoxDecoration(
          //         border: Border.all(color: Colors.white),
          //         borderRadius: BorderRadius.circular(10.0),
          //       ),
          //     ),
          //     daysOfWeekStyle: DaysOfWeekStyle(
          //       weekdayStyle: TextStyle(fontSize: 15, color: Colors.white),
          //       weekendStyle: TextStyle(fontSize: 15, color: Colors.red),
          //     ),
          //     calendarStyle: CalendarStyle(
          //       defaultTextStyle: TextStyle(color: Colors.white),
          //
          //       // Customize the appearance of the calendar
          //
          //       selectedDecoration: BoxDecoration(
          //         color: Colors.blue,
          //         shape: BoxShape.circle,
          //       ),
          //       todayDecoration: BoxDecoration(
          //         color: Colors.orange,
          //         shape: BoxShape.circle,
          //       ),
          //       selectedTextStyle: TextStyle(
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //       ),
          //       todayTextStyle: TextStyle(
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //       ),
          //       weekendTextStyle: TextStyle(
          //         color: Colors.red,
          //       ),
          //       outsideTextStyle: TextStyle(
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: timesheet
                  .length, // Use timesheet data instead of widget.tasks

              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(timesheet[index]['title'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(timesheet[index]['start'] ?? ''),
                        Text(timesheet[index]['end'] ?? ''),
                      ],
                    ),
                    trailing: Container(
                      width: 48.0, // Set the desired width
                      child: Row(
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            onTap: () {
                              _showEditTimeDialog(context, timesheet[index]);
                              // Handle edit onTap
                            },
                          ),
                          InkWell(
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onTap: () {
                              _showDeleteTimeDialog(
                                  context, timesheet[index]['id']);
                              // Handle delete onTap
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
            Navigator.pushNamed(context, '/addTimesheet');

            //*******    ui  ****** //
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => Addtimesheet(
            //       onAddTask: (List<Tasks> updatedTasks) {
            //         // Handle the added tasks here in the parent widget
            //         // setState(() {
            //         //   widget.tasks.clear();
            //         //   widget.tasks.addAll(updatedTasks as Iterable<Task>);
            //         // });
            //       },
            //     ),
            //   ),
            // );

            //*******    ui  ****** //
          },
        ),
      ),
    );
  }
}

Future<void> _showEditTimeDialog(
    BuildContext context, Map<String, dynamic> timeDetails) async {
  await showDialog(
    context: context,
    builder: (context) {
      return EditTimeDialog(timeDetails: timeDetails);
    },
  );
}

Future<void> _showDeleteTimeDialog(BuildContext context, int timeId) async {
  return showDialog(
    context: context,
    builder: (context) {
      return DeleteTimeDialog(timeId: timeId); // Pass the leaveId
    },
  );
}

class Task {
  final String project;
  final String? description;
  final DateTime date;
  final String startTime;
  final String endTime;

  Task({
    required this.project,
    this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
}
