import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Data_service/Timesheet_api.dart';
import '../constant/url.dart';
import '../models/Constants.dart';

class Addtimesheet extends StatefulWidget {
  // final Function(List<Tasks>) onAddTask;

  // const Addtimesheet({Key? key, required this.onAddTask, }) : super(key: key);

  @override
  State<Addtimesheet> createState() => _AddtimesheetState();
}

class _AddtimesheetState extends State<Addtimesheet> {
  List<Tasks> tasks = []; // Create a list to store tasks
  String? description; // Use String? for nullable string

  DateTime _selectedStartDate = DateTime.now(); // Change to DateTime
  DateTime _selectedEndDate = DateTime.now(); // Change to DateTime
  String dropdownValue = 'Select your project'; // Corrected variable name
  // TimeOfDay _selectedTime = TimeOfDay.now();
  var projects = [
    'Select your project',
    'Learning',
    'Team Building',
    'Lunch / Tea Break',
    'Permission',
    'On-Duty',
    'Miscellaneous',
  ];
  void _addTask(Tasks task) {
    setState(() {
      tasks.add(task);
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedStartDate) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedStartDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedStartDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedEndDate) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedEndDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedEndDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  final ApiService apiService =
      ApiService(ADD_TIMESHET); // Initialize the API service

  Future<void> _saveTimeSheet() async {
    String project = dropdownValue;
    String describe = description ?? '';

    try {
      await apiService.addTimeSheet(
        project: project,
        description: describe,
        startDate: _selectedStartDate,
        endDate: _selectedEndDate,
        tokens: tokens, // Make sure you have tokens defined somewhere
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
    }
  }

  //**********         API function         *************//

  // Future<void> _saveTimeSheet() async {
  //   String project = dropdownValue;
  //
  //   String describe = description ?? '';
  //   // Format the selected dates as strings
  //   String startDate =
  //       DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedStartDate);
  //   String endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedEndDate);
  //
  //   final apiUrl = ADD_TIMESHET; // Replace with your Laravel API endpoint URL
  //   print(description);
  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $tokens',
  //     },
  //     body: {
  //       'title': project,
  //       "type": "add",
  //       'desc': describe,
  //       'start': startDate,
  //       'end': endDate,
  //     },
  //   );
  //   print(response.statusCode);
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     // Time sheet data was successfully added
  //     // You can handle the success scenario here
  //     print('Time sheet added successfully!');
  //   } else {
  //     // Handle error
  //     print('Error adding time sheet: ${response.body}');
  //   }
  // }

  //*********  API Function      ********//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Sheet'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 180, // Adjust the height as needed
                width: double.infinity,
                child: Image.asset(
                  'assets/images/time.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        // Specify the type for DropdownButtonFormField
                        value: dropdownValue,
                        dropdownColor: Colors.lightBlueAccent,

                        items: projects.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a description...',
                        ),
                      ),
                      // SizedBox(height: 10.0),
                      // TextField(
                      //   decoration: InputDecoration(
                      //       border: OutlineInputBorder(),
                      //       hintText: DateFormat.yMd().format(_selectedDate),
                      //       // hintText: 'Enter a date',
                      //       suffixIcon: IconButton(
                      //         icon: Icon(Icons.calendar_month_outlined,
                      //             color: Colors.white),
                      //         onPressed: () {
                      //           _showDatePicker();
                      //         },
                      //       )),
                      // ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  style: TextStyle(color: Colors.white),
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text: DateFormat('yyyy-MM-dd')
                                          .format(_selectedStartDate)),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Start Date',
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.calendar_today,
                                          color: Colors.white),
                                      onPressed: () {
                                        _selectStartDate(context);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  style: TextStyle(color: Colors.white),
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text: DateFormat('yyyy-MM-dd')
                                          .format(_selectedEndDate)),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'End Date',
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.calendar_today,
                                          color: Colors.white),
                                      onPressed: () {
                                        _selectEndDate(context);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _saveTimeSheet();

                  // Navigate back to the previous screen
                  Navigator.pop(context);
                },
                child: Text('Add task'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Tasks {
  final String project;
  final String description;
  final DateTime startDate; // Add startDate
  final DateTime endDate; // Add endDate

  Tasks({
    required this.project,
    required this.description,
    required this.startDate,
    required this.endDate,
  });
}
