// api_functions.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/url.dart';

class APIFunctions {
  static Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    final String apiUrl = LOGIN;

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(apiUrl));
      request.body = json.encode({"email": email, "password": password});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final token = await response.stream.bytesToString();
        Map<String, dynamic> user = jsonDecode(token);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user['token']);
        // Navigate to the home screen after successful login
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Failed to log in
        // Show an error message to the user
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Login Failed"),
            content: Text("Invalid email or password"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Error occurred while making the request
      // Show an error message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("An error occurred. Please try again later."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
