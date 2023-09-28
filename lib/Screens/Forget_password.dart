import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image(
            fit: BoxFit.cover, // Stretch the image to cover full width
            height: 250,
            width: double.infinity,
            image: AssetImage('assets/images/forget.jpg'),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 40.0), // Apply horizontal padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Dont Worry !',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Enter your email for the verification process,\n'
                  ' we will send 4 digit code to your email',
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
                          Icons.person,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'User Id',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
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
                          Icons.mail,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
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
                      'Forget Password',
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
