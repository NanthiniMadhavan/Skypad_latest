import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constant/url.dart';
import '../models/Constants.dart';
import 'EditExpense.dart';

class ShowmoreExpenses extends StatelessWidget {
  final Map<String, dynamic> expenseDetails;

  ShowmoreExpenses({
    required this.expenseDetails,
  });

  // void _deleteExpense(BuildContext context) async {
  //   final int expenseId = expenseDetails[
  //       'id']; // Replace 'id' with the actual key for the expense ID
  //   final String deleteUrl =
  //       '$EXPENSEDELETE/$expenseId'; // Replace with your actual base URL
  //
  //   try {
  //     final response = await http.delete(Uri.parse(deleteUrl));
  //
  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Deleted successfully.')),
  //       );
  //       // Expense deleted successfully
  //       Navigator.pop(context); // Navigate back to the previous screen
  //     } else {
  //       // Handle error
  //       print('Error deleting expense: ${response.statusCode}');
  //       // Show an error message to the user
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to delete the expense.')),
  //       );
  //     }
  //   } catch (e) {
  //     // Handle error
  //     print('Error deleting expense: $e');
  //     // Show an error message to the user
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred. Please try again later.')),
  //     );
  //   }
  // }

  Future<void> _deleteExpense(int expenseDetails) async {
    final apiUrl =
        '$EXPENSEDELETE/$expenseDetails'; // Append the leaveId to the URL

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

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Expense'),
          content: Text('Are you sure you want to delete this expense?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final int expenseId = expenseDetails['id'] as int;
                _deleteExpense(expenseId); // Pass the expense ID as an int
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 220, // Adjust the height as needed
              width: double.infinity,
              child: Image.asset(
                'assets/images/show.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Date: ${expenseDetails['date']}',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Name: ${expenseDetails['name']}',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Categories: ${expenseDetails['categories']}',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Sub-categories: ${expenseDetails['sub_categories']}',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Description: ${expenseDetails['description']}',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Amount: ${expenseDetails['amount']}',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Spent by: ${expenseDetails['spent_by']}',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Payments: ${expenseDetails['payments']}',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'GST: ${expenseDetails['gst']}',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(
                    color: Colors.grey,
                  ), // Add some spacing between the card and buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditExpense(expenseDetails: expenseDetails),
                              ),
                            );
                            // Implement your edit logic here
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.orangeAccent,
                          )),
                      IconButton(
                          onPressed: () {
                            _showDeleteConfirmationDialog(context);
                          },
                          icon: Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.red,
                          ))
                    ],
                  ), // Add more details here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
