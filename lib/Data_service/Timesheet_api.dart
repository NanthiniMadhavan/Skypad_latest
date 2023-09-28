// timesheet_api.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constant/url.dart';
import '../models/Constants.dart';

class TimesheetAPI {
  static Future<List<dynamic>> fetchTimesheet() async {
    final apiUrl = TIMESHEET_VIEW;
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokens',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error fetching Time sheet: ${response.body}');
        return [];
      }
    } catch (error) {
      print('Error connecting to the API: $error');
      return [];
    }
  }

// Add other API functions as needed
}

class ApiService {
  final String apiUrl; // Replace with your API endpoint URL

  ApiService(this.apiUrl);

  Future<void> addTimeSheet({
    required String project,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String tokens,
  }) async {
    try {
      String startDateFormat =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate);
      String endDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokens',
        },
        body: {
          'title': project,
          'type': "add",
          'desc': description,
          'start': startDateFormat,
          'end': endDateFormat,
        },
      );

      if (response.statusCode == 200) {
        // Handle success scenario here
        print('Time sheet added successfully!');
      } else {
        // Handle error
        print('Error adding time sheet: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
    }
  }
}

class EditApiService {
  final String apiUrl; // Replace with your API endpoint URL
  final String tokens; // Your authentication token

  EditApiService(this.apiUrl, this.tokens);

  Future<void> updateTime({
    required int id,
    required String project,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      String startDateFormat =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate);
      String endDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate);

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
          'start': startDateFormat,
          'end': endDateFormat,
        },
      );

      if (response.statusCode == 200) {
        // Handle success scenario here
        print('Time sheet updated successfully!');
      } else {
        // Handle error
        print('Error updating time sheet: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
    }
  }
}

class DeletetimeApiService {
  final String apiUrl; // Replace with your API endpoint URL
  final String tokens; // Your authentication token

  DeletetimeApiService(this.apiUrl, this.tokens);

  Future<void> deleteTime(int timeId) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokens',
        },
        body: {
          'id': timeId.toString(),
          "type": "delete",
        },
      );

      if (response.statusCode == 200) {
        // Handle success scenario here
        print('Time sheet deleted successfully!');
      } else {
        // Handle error
        print('Error deleting time sheet: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
    }
  }
}
