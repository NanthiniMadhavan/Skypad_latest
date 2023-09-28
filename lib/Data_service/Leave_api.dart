import 'dart:convert';

import 'package:http/http.dart' as http;

class LeaveApiService {
  final String apiUrl;
  final String tokens;

  LeaveApiService(this.apiUrl, this.tokens);

  Future<List<dynamic>> loadLeaveRequests() async {
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
          return responseData['leaves'];
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

  Future<Map<String, dynamic>> fetchLeaveCounts() async {
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokens',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData; // Return the leave counts as a Map
      } else {
        print(
            'Error fetching leave counts. Status Code: ${response.statusCode}');
        print('Error Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error connecting to the API: $error');
    }

    return {'casual': 0, 'sick': 0}; // Return an empty Map in case of error
  }
}

// class AddLeaveApiService {
//   final String apiUrl;
//   final String tokens;
//
//   AddLeaveApiService(this.apiUrl, this.tokens);
//
//   Future<void> addLeave({
//     required String saasId,
//     required String employeeId,
//     required String startDate,
//     required String endDate,
//     required String reason,
//     required String session,
//   }) async {
//     final apiUrl = ADD_LEAVE;
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $tokens',
//         },
//         body: {
//           'saas_id': saasId,
//           'employee_id': employeeId,
//           'date_from': startDate,
//           'date_to': endDate,
//           'reason': reason,
//           'remarks': reason,
//           'session': session,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         print('Leave added successfully!');
//       } else {
//         print('Error adding leave: ${response.body}');
//       }
//     } catch (error) {
//       print('HTTP Request Error: $error');
//     }
//   }
// }
