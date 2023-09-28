import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constant/url.dart';
import '../models/Constants.dart';

class DeleteTimeDialog extends StatelessWidget {
  final int timeId; // Add this field to store the leave ID

  DeleteTimeDialog({required this.timeId});
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete TimeSheet', style: TextStyle(color: Colors.black)),
      content: Text('Are you sure you want to delete this leave request?',
          style: TextStyle(color: Colors.black)),
      actions: [
        TextButton(
          onPressed: () {
            _deleteTime(timeId);

            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Delete'),
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
}

Future<void> _deleteTime(int timeId) async {
  print(timeId);
  final apiUrl = ADD_TIMESHET; // Replace with your Laravel API endpoint URL
  print(apiUrl);
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokens',
    },
    body: {'id': timeId.toString(), "type": "delete"},
  );
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    // Time sheet data was successfully added
    // You can handle the success scenario here
    print('Time sheet deleted successfully!');
  } else {
    // Handle error
    print('Error delete time sheet: ${response.body}');
  }
}
