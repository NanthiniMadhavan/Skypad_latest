import 'dart:convert';

import 'package:http/http.dart' as http;

/// A service class for interacting with the dashboard leave API.
class DashboardleaveApiService {
  final String apiUrl; // The URL of the API endpoint.
  final String tokens; // The authorization token for API access.
  /// Creates an instance of the DashboardleaveApiService.
  ///
  /// [apiUrl]: The URL of the API endpoint.
  /// [tokens]: The authorization token for API access.
  ///
  DashboardleaveApiService(this.apiUrl, this.tokens);

  /// Retrieves a list of leave data from the dashboard API.
  ///
  /// Returns a list of leave data if successful, or an empty list if no data is available
  /// or an error occurs during the API request.
  Future<List<dynamic>> dashboardleaveview() async {
    final headers = {
      'Accept': 'application/json',
      'Authorization':
          'Bearer $tokens', //The authorization token for API access.
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      print(response.statusCode);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final responseData = jsonDecode(response.body);
          return responseData['admin'];
        } else {
          print('No leave requests available.');
          return [];
        }
      } else {
        print('Error fetching leave requests: ${response.body}');
        return [];
      }
    } catch (error) {
      print('Error connecting to the API: $error');
      return [];
    }
  }
}
