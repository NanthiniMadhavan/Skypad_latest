import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constant/url.dart';
import '../models/Constants.dart';

class EditTimeDialog extends StatefulWidget {
  final Map<String, dynamic> timeDetails;

  EditTimeDialog({required this.timeDetails});

  @override
  _EditTimeDialogState createState() => _EditTimeDialogState();
}

class _EditTimeDialogState extends State<EditTimeDialog> {
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  String? dropdownValue;
  var projects = [
    'Select your project',
    'Learning',
    'Team Building',
    'Lunch / Tea Break',
    'Permission',
    'On-Duty',
    'Miscellaneous',
  ];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Parse date and time strings from widget.timeDetails
    final startTimeString = widget.timeDetails['start'] as String;
    final endTimeString = widget.timeDetails['end'] as String;

    _titleController.text = widget.timeDetails['title'] ?? '';

    // Parse and assign date and time values
    _selectedStartDate = DateTime.parse(startTimeString);
    _selectedEndDate = DateTime.parse(endTimeString);

    _startController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(_selectedStartDate);
    _endController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(_selectedEndDate);

    dropdownValue = widget.timeDetails['title'] ?? null;
  }

  // final EditApiService apiService = EditApiService(ADD_TIMESHET,
  //     tokens); // Initialize the API service with your endpoint URL and tokens
  //
  // Future<void> _updateTime(int id) async {
  //   String project = dropdownValue ?? '';
  //
  //   try {
  //     await apiService.updateTime(
  //       id: id,
  //       project: project,
  //       startDate: _selectedStartDate,
  //       endDate: _selectedEndDate,
  //     );
  //
  //     Navigator.of(context).pop(); // Close the dialog
  //   } catch (e) {
  //     // Handle any exceptions
  //     print('Error: $e');
  //   }
  // }

  //**********         API function         *************//

  Future<void> _updateTime(int id) async {
    String project = dropdownValue ?? '';

    // Format the selected dates as strings
    String startDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedStartDate);
    String endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(_selectedEndDate);

    final apiUrl = ADD_TIMESHET; // Replace with your Laravel API endpoint URL
    print(apiUrl);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokens',
      },
      body: {
        'id': id.toString(),
        'title': project,
        "type": "update",
        'start': startDate,
        'end': endDate,
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      // Time sheet data was successfully added
      // You can handle the success scenario here
      print('Time sheet updated successfully!');
    } else {
      // Handle error
      print('Error updating time sheet: ${response.body}');
    }
  }

  //**********         API function         *************//

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

          // Update the text field with the selected date and time
          _startController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(_selectedStartDate);
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

          // Update the text field with the selected date and time
          _endController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(_selectedEndDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Time Sheet',
        style: TextStyle(color: Colors.black),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: projects.map<DropdownMenuItem<String>>((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value ?? ''),
                );
              }).toList(),
              decoration: InputDecoration(
                  labelText: 'Project',
                  labelStyle: TextStyle(color: Colors.black)
                  // suffixIcon: Icon(Icons.arrow_drop_down_circle_rounded),
                  ),
            ),
            TextField(
              controller: _startController,
              onTap: () => _selectStartDate(context),
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Start Time',
                suffixIcon: Icon(Icons.calendar_month, color: Colors.black),
              ),
            ),
            TextField(
              controller: _endController,
              onTap: () => _selectEndDate(context),
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'End Time',
                suffixIcon: Icon(Icons.calendar_month, color: Colors.black),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    int id = widget.timeDetails['id'] as int;
                    _updateTime(id);
                    Navigator.of(context).pop();
                  },
                  child: Text('Update'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
