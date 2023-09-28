import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image(
            fit: BoxFit.cover, // Stretch the image to cover full width
            height: 250,
            width: double.infinity,
            image: AssetImage('assets/images/reset.jpg'),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 40.0), // Apply horizontal padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Change Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Set the new password for your account',
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
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
                            decoration: InputDecoration(
                              hintText: 'New Password',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
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
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                SizedBox(
                  height: 52,
                  width:
                      double.infinity, // Button width spans the available width
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'verify');
                    },
                    child: Text(
                      'Reset Password',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
