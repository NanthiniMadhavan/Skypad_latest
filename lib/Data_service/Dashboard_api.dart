import 'dart:convert';

import 'package:http/http.dart' as http;

class DashboardleaveApiService {
  final String apiUrl;
  final String tokens;

  DashboardleaveApiService(this.apiUrl, this.tokens);

  Future<List<dynamic>> dashboardleaveview() async {
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokens',
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
