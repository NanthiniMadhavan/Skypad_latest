import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Data_service/Login_api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool value = false;
  bool isPasswordVisible = false;
  bool isCheckedRememberMe = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
// **** api (login final) ***//
  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    await APIFunctions.login(email, password, context);
  }

// **** api (login final) ***//
  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  actionRememberMe(bool value) {
    isCheckedRememberMe = value;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool('rememberme', value);
        prefs.setString('email', _emailController as String);
        prefs.setString('password', _passwordController as String);
      },
    );
    setState(() {
      isCheckedRememberMe = value;
    });
  }

// **** UI  (login) ***** //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // safearea for mobile responsive
        child: SingleChildScrollView(
          // Wrap content with SingleChildScrollView
          child: Container(
            padding: EdgeInsets.only(top: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(48),
                    child: Image.asset('assets/images/login.jpg',
                        fit: BoxFit.cover),
                  ),
                ),
                // SizedBox(height: 20),
                // Container(
                //   child: Text(
                //     'Welcome Back',
                //     style: TextStyle(
                //       fontSize: 20.0,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
                SizedBox(height: 20),
                Container(
                  child: Text(
                    'Login to your account',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  obscureText: !isPasswordVisible,
                                ),
                              ),
                              InkWell(
                                onTap: _togglePasswordVisibility,
                                child: Icon(
                                  isPasswordVisible // password visibility (show/hide password)
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(width: 10),
                          Checkbox(
                            side: BorderSide(
                                color: Color(0xFF0F5EF7),
                                strokeAlign: BorderSide.strokeAlignInside),
                            value:
                                isCheckedRememberMe, // rememberme function for save the mail and password to your data storage
                            activeColor: Colors.lightGreen,

                            checkColor: Color(0XFF263238),
                            onChanged: (bool? newValue) {
                              setState(() {
                                isCheckedRememberMe = newValue ?? false;
                              });
                            },
                            // onChanged: actionRememberMe(isCheckedRememberMe),
                          ),
                          Text(
                            'Remember me',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forgetpassword');
                            },
                            child: Text(
                              'Forget Password ?',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.0),
                SizedBox(
                  height: 52, //height of button
                  width: 180, //width of button equal to parent widget
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      _login();
                    },
                    child: Text(
                      'Submit',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// **** UI  (login) ***** //

//                        Working To         //

// final response = await http.post(
//   Uri.parse(apiUrl),
//   headers: {'Content-Type': 'application/json'},
//   body: jsonEncode({"email": email, "password": password}),
// );

// if (response.statusCode == 200) {
//   // Successfully logged in
//   print("Success: ${response.body}");
//   final token = response.body;
//   Map<String, dynamic> user = jsonDecode(token);
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('token', user['token']);
//   fetchtoken();
//   // Navigate to the home screen after successful login
//   Navigator.pushReplacementNamed(context, '/home');
// } else {
//   // Failed to log in
//   print("Failed: ${response.body}");
//   // Show an error message to the user
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text("Login Failed"),
//       content: Text("Invalid email or password"),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text("OK"),
//         ),
//       ],
//     ),
//   );
// }

// **** api (login final) ***//

// Replace "http://your_api_endpoint" with your actual Laravel API endpoint for login
//     final String apiUrl = LOGIN;
//     // final String apiUrl = "http://skypad.in/api/admin/login";
//     try {
//  api    *******                            Working From             *******            //
//
//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request(
//           // 'POST', Uri.parse('http://3.109.61.187/test/api/admin/login'));
//           'POST',
//           Uri.parse(apiUrl));
//       request.body = json.encode({"email": email, "password": password});
//       request.headers.addAll(headers);
//
//       http.StreamedResponse response = await request.send();
//
//       if (response.statusCode == 200) {
//         final token = await response.stream.bytesToString();
//         print("Success: ${token}");
//         Map<String, dynamic> user = jsonDecode(token);
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', user['token']);
//         fetchtoken();
//         // Navigate to the home screen after successful login
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         // Failed to log in
//         // Show an error message to the user
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text("Login Failed"),
//             content: Text("Invalid email or password"),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text("OK"),
//               ),
//             ],
//           ),
//         );
//       }

// } catch (e) {
//   // Error occurred while making the request
//   print("Error: $e");
//   // Show an error message to the user
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text("Error"),
//       content: Text("An error occurred. Please try again later."),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text("OK"),
//         ),
//       ],
//     ),
//   );
// }

// **** api (login final) ***//
