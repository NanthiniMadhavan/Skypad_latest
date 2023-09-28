import 'package:flutter/material.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image(
            fit: BoxFit.cover, // Stretch the image to cover full width
            height: 250,
            width: double.infinity,
            image: AssetImage('assets/images/verify.jpg'),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 40.0), // Apply horizontal padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Enter 4 Digit Code',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Enter your 4 digit code that you received on \n'
                  'your email',
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(),
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
                      Navigator.pushNamed(context, '/reset');
                    },
                    child: Text(
                      'Verify',
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
