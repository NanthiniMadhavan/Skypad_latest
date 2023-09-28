import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/url.dart';
import '../models/Constants.dart';

class ExpensesApi {
  static Future<List<dynamic>> loadExpenses() async {
    final apiUrl = LIST_EXPENSES;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokens',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['expense'];
    } else {
      print('Error fetching expenses: ${response.body}');
      throw Exception('Error fetching expenses');
    }
  }
}

class EditExpenseApi {
  static Future<void> updateExpense(
    int expenseId,
    String name,
    String categories,
    String subCategories,
    String date,
    String location,
    String amount,
    String spentBy,
    String modeOfPayment,
  ) async {
    final apiUrl = '$EXPENSEUPDATE/$expenseId';

    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokens',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final Map<String, String> body = {
      'name': name,
      'date': date,
      'categories': categories,
      'sub_categories': subCategories,
      'location': location,
      'description': 'description',
      'amount': amount,
      'spent_by': spentBy,
      'payments': modeOfPayment,
      'gst': modeOfPayment,
    };

    final response =
        await http.put(Uri.parse(apiUrl), headers: headers, body: body);

    print('Request Body: $body');
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Expense successfully updated
      print('Expense updated!');
    } else {
      // Handle error
      print('Error updating expense: ${response.body}');
    }
  }
}
