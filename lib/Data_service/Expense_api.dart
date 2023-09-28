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
