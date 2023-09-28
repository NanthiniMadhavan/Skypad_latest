import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constant/url.dart';
import '../models/Constants.dart';

class DeleteLeaveDialog extends StatelessWidget {
  final int leaveId; // Add this field to store the leave ID

  DeleteLeaveDialog({required this.leaveId});
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Leave', style: TextStyle(color: Colors.black)),
      content: Text('Are you sure you want to delete this leave request?'),
      actions: [
        TextButton(
          onPressed: () {
            // setState(() {
            //   leaveRequests.removeAt(index);
            // });
            _deleteLeave(leaveId);
            // _deleteLeave();
            // Add your delete logic here
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

Future<void> _deleteLeave(int leaveId) async {
  final apiUrl = '$LEAVE_DELETE/$leaveId'; // Append the leaveId to the URL

  try {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer $tokens', // Replace with your authentication logic
      },
    );

    print('Delete Leave Response Status Code: ${response.statusCode}');
    print('Delete Leave Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Check if the response body is empty
      if (response.body.isEmpty) {
        print('Empty response body');
        // Handle the case where the response body is empty
        // For example, you can show a message to the user indicating success with no additional data
      } else {
        final responseData = jsonDecode(response.body);
        print('Delete Leave Response Data: $responseData');
        // Handle success as per your application's requirements
      }
    } else {
      // Handle error cases
      print('Error deleting leave: ${response.body}');
      // Handle error as per your application's requirements
    }
  } catch (error) {
    print('Error deleting leave: $error');
    // Handle error as per your application's requirements
  }
}
