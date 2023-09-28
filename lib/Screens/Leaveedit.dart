import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sky_pad/models/Constants.dart';

import '../constant/url.dart';
// import 'constants.dart'; // Import your other constants

class EditLeaveDialog extends StatefulWidget {
  final String leaveDetailsEndpoint;

  EditLeaveDialog({required this.leaveDetailsEndpoint});

  @override
  _EditLeaveDialogState createState() => _EditLeaveDialogState();
}

class _EditLeaveDialogState extends State<EditLeaveDialog> {
  Map<String, dynamic> _editleave = {}; // Initialize with an empty map
  String? dropdownValue;
  String sessionValue = 'Select your session';
  String? reason;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final leave = ['Select the type of leave', 'Casual', 'Sick'];
  final session = ['Select your session', '1st session', '2nd session'];
  final TextEditingController _reasoncontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(tokens);
    // print(widget.leaveDetailsEndpoint);
    if (widget.leaveDetailsEndpoint.isNotEmpty) {
      // Fetch the leave data using the endpoint provided
      _fetchLeaveDetails(widget.leaveDetailsEndpoint);
    }
  }

  void _fetchLeaveDetails(String leaveDetailsEndpoint) async {
    print('**************');
    print(leaveDetailsEndpoint);
    try {
      final apiUrl = '$LEAVE_EDIT/$leaveDetailsEndpoint';
      print(apiUrl);
      print(tokens);
      // Replace with your API endpoint for fetching leave details
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer $tokens', // Replace with your authentication logic
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _editleave = responseData['leave'];
          initializeFields();
          print('API Response: $_editleave');
        });
      } else {
        // Handle non-200 status codes, e.g., show an error message to the user.
        print(
            'Error fetching leave details. Status Code: ${response.statusCode}');
        print('Error Response Body: ${response.body}');
        // Handle the error here, e.g., show an error message to the user.
      }
    } catch (error) {
      print('Error fetching leave details: $error');
      // Handle the error here, e.g., show an error message to the user.
    }
  }

  void initializeFields() {
    dropdownValue =
        _editleave['reason']?.toString() ?? 'Select the type of leave';
    sessionValue = _editleave['session']?.toString() ?? 'Select your session';
    _reasoncontroller.text = _editleave['remarks']?.toString() ??
        ''; // Set the text of _reasoncontroller
    _startDate = DateTime.parse(
        _editleave['date_from']?.toString() ?? DateTime.now().toString());
    _endDate = DateTime.parse(
        _editleave['date_to']?.toString() ?? DateTime.now().toString());
    print(dropdownValue);
    print(sessionValue);
    print(_reasoncontroller.text); // Print the text of _reasoncontroller
    print(_startDate);
    print(_endDate);
  }

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

  Future<void> _updateLeave() async {
    final apiUrl = LEAVE_UPDATE;

    Map<String, dynamic> requestBody = {
      'id': _editleave['id'],
      'employee_id': _editleave['employee_id'],
      'date_from': DateFormat('yyyy-MM-dd').format(_startDate),
      'date_to': DateFormat('yyyy-MM-dd').format(_endDate),
      'reason': dropdownValue,
      'remarks': _reasoncontroller.text,
      'session': sessionValue == '1st session' ? '1st session' : '2nd session',
    };

    try {
      if (!mounted) {
        // Check if the widget is still mounted
        return;
      }

      final response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokens',
          'Accept': 'application/json', // Set the Accept header for JSON
        },
      );

      if (!mounted) {
        // Check again after the asynchronous operation
        return;
      }
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Leave updated successfully');
        _showSuccessNotification(context);
        Navigator.of(context).pop(); // Close the dialog on success
      } else {
        print('Failed to update leave. Status code: ${response.statusCode}');
        // Handle error here, e.g., display an error message to the user
      }
    } catch (error) {
      if (mounted) {
        // Handle error here, e.g., display an error message to the user
        print('Error updating leave: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Leave',
        style: TextStyle(color: Colors.black),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    style: TextStyle(color: Colors.black),
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
              controller: _reasoncontroller, // Bind the controller
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                setState(() {
                  reason = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a Reason',
                hintStyle: TextStyle(color: Colors.black),
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
                    style: TextStyle(color: Colors.black),
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
                          hintText: DateFormat.yMd().format(_startDate),
                          hintStyle: TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.black,
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
                          hintStyle: TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.black,
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
      actions: [
        TextButton(
          onPressed: () {
            // Implement update logic
            _updateLeave();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Update'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  void _showSuccessNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Leave updated successfully'),
        duration: Duration(seconds: 2), // You can adjust the duration
      ),
    );
  }
}
