import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constant/url.dart'; // Make sure you have this import properly configured.
import '../models/Constants.dart'; // Make sure you have this import properly configured.

class Addleave extends StatefulWidget {
  const Addleave({Key? key}) : super(key: key);

  @override
  State<Addleave> createState() => _AddleaveState();
}

class _AddleaveState extends State<Addleave> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Map<String, dynamic> _profile = {};
  String successMessage = '';
  String dropdownValue = 'Select the type of leave';
  String sessionValue = 'Select your session';
  String? reason;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final leave = ['Select the type of leave', 'Casual', 'Sick'];
  final session = ['Select your session', '1st session', '2nd session'];

  Future<void> _showStartDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  Future<void> _showEndDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _endDate) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchtoken();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final apiUrl =
        PROFILE; // Replace with your Laravel API endpoint URL to fetch the profile
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer $tokens', // Replace with your authentication logic
        },
      );
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Profile successfully fetched
        Map<String, dynamic> responseData = jsonDecode(response.body);

        print('Response Body: ${responseData['data']}');

        setState(() {
          _profile = responseData['data'];
          print(_profile);
        });
      } else {
        // Handle error
        print('Error fetching profile details: ${response.body}');
      }
    } catch (error) {
      print('Error loading profile: $error');
    }
  }

  // Define a function to reset all input fields
  void _resetFormFields() {
    setState(() {
      dropdownValue = 'Select the type of leave';
      sessionValue = 'Select your session';
      reason = null;
      _startDate = DateTime.now();
      _endDate = DateTime.now();
    });
  }

  Future<void> _addleave() async {
    // Check if _profile['employee_id'] is not null before using it

    String? employeeId = _profile['name']?.toString();
    String? saas_id = _profile['saas_id']?.toString();
    if (employeeId == null) {
      setState(() {
        successMessage = 'Error adding leave. Employee ID is null.';
      });
      return;
    }

    String leaveReason = reason ?? '';
    String startDate = DateFormat('yyyy-MM-dd').format(_startDate);
    String endDate = DateFormat('yyyy-MM-dd').format(_endDate);
    String session = sessionValue ?? '';
    final apiUrl =
        ADD_LEAVE; // Replace with your API endpoint for leave creation
    print(startDate);
    print(endDate);
    print(leaveReason);
    print(_profile['emp_id']?.toString());
    print(_profile['saas_id']?.toString());
    print(employeeId);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokens',
        },
        body: {
          'saas_id': saas_id,
          'employee_id': employeeId,
          'date_from': startDate,
          'date_to': endDate,
          'reason': dropdownValue,
          'remarks': leaveReason,
          // 'no_of_days': "2",
          'session': session,
          // 'tdays': "2023-09-11,2023-09-12,2023-09-13"

          // Add other fields as needed
        },
      );
      print('HTTP Response Status Code: ${response.statusCode}');
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          successMessage = 'Leave added successfully!';
        });

        print('Leave added successfully!');
        // Clear the input fields by calling the reset function
        _resetFormFields();
        // Show success message for 3 seconds and then clear it
        await Future.delayed(Duration(seconds: 3));
        setState(() {
          successMessage = '';
        });
      } else {
        await Future.delayed(Duration(seconds: 3));
        // Handle error
        print('Error adding leave: ${response.body}');

        setState(() {
          successMessage = 'Error adding leave. Please try again.';
        });
      }
    } catch (error) {
      print('HTTP Request Error: $error');
      // Handle the error
      setState(() {
        // successMessage = 'Leave added successfully!';
        successMessage = 'Error adding leave. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Leave'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 180, // Adjust the height as needed
                width: double.infinity,
                child: Image.asset(
                  'assets/images/leave.jpg',
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
                      TextField(
                        enabled: false, // Make it non-editable
                        controller: TextEditingController(
                            text: _profile['emp_id'] ?? ''),
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        value: dropdownValue,
                        dropdownColor: Colors.lightBlueAccent,
                        items: leave.map((String item) {
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
                            reason = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a Reason',
                        ),
                      ),
                      SizedBox(height: 10.0),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        value: sessionValue,
                        dropdownColor: Colors.lightBlueAccent,
                        items: session.map((String item) {
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
                            sessionValue = newValue!;
                          });
                        },
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    helperText: 'Start Date',
                                    hintText:
                                        DateFormat.yMd().format(_startDate),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.calendar_month_outlined,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        _showStartDatePicker();
                                      },
                                    ),
                                  ),
                                  readOnly: true, // Make it non-editable
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    helperText: 'End Date',
                                    hintText: DateFormat.yMd().format(_endDate),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.calendar_month_outlined,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        _showEndDatePicker();
                                      },
                                    ),
                                  ),
                                  readOnly: true, // Make it non-editable
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
                onPressed: () {
                  _addleave();
                },
                child: Text(
                  'Add leave',
                ),
              ),
              if (successMessage.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 16.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    successMessage,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
