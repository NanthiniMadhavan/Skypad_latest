import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constant/url.dart'; // Import your URL constants here

class ProfileApi {
  static Future<Map<String, dynamic>> fetchProfile(String tokens) async {
    final apiUrl =
        PROFILE; // Replace with your Laravel API endpoint URL to fetch profile
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokens',
      },
    );

    if (response.statusCode == 200) {
      // Profile successfully fetched
      Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['data'];
    } else {
      // Handle error
      print('Error fetching profile details: ${response.body}');
      return {}; // Return an empty map or handle the error case as needed
    }
  }
}

class EditProfileApi {
  static Future<Map<String, dynamic>> updateProfile({
    required String tokens,
    required String name,
    required String email,
    required String empId,
    File? profileImageFile,
  }) async {
    final apiUrl = EDIT_PROFILE;

    Map<String, dynamic> requestBody = {
      'name': name,
      'email': email,
      'emp_id': empId,
    };

    if (profileImageFile != null) {
      requestBody['profile_photo_path'] =
          base64Encode(profileImageFile.readAsBytesSync());
    }

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokens',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        throw Exception('Failed to update profile');
      }
    } catch (error) {
      print('Error updating profile: $error');
      throw Exception('Error updating profile');
    }
  }
}
