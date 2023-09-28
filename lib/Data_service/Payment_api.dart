import 'dart:convert';

import 'package:http/http.dart' as http;

class PaymentApiService {
  final String apiUrl;
  final String tokens;

  PaymentApiService(this.apiUrl, this.tokens);

  Future<List<dynamic>> paymentview() async {
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
          return responseData['data'];
        } else {
          print('No payments list available.');
          return [];
        }
      } else {
        print('Error fetching payment requests: ${response.body}');
        return [];
      }
    } catch (error) {
      print('Error connecting to the API: $error');
      return [];
    }
  }
}
