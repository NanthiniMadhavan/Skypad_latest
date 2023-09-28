import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // initial screen
  @override
  Widget build(BuildContext context) {
    // ThemeData themeData = getAppTheme();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                width: 400,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the quiz screen
                Navigator.pushNamed(context, '/login');
                // Navigate to the level screen
              },
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Get Started',
                  ),
                  // SizedBox(
                  //   width: 5.0,
                  // ),
                  Icon(
                    Icons.arrow_right,
                    size: 40,
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 25,
            // ),
          ],
        ),
      ),
    );
  }
}
