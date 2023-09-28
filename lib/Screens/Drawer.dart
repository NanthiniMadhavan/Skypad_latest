import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginScreen.dart';

class CustomAppdrawer extends StatelessWidget {
  const CustomAppdrawer({Key? key}) : super(key: key);

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Remove the authentication token
    // You may also clear other user-related data if necessary
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF27374D),
            ),
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 150,
                  height: 100,
                ),
              ],
            ),
          ),

          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              // Navigate to the dashboard screen
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Leaves'),
            onTap: () {
              // Navigate to the leaves screen
              Navigator.pushNamed(context, '/leaves');
            },
          ),
          ListTile(
            leading: Icon(Icons.watch_later),
            title: Text('Time Sheet'),
            onTap: () {
              // Navigate to the dashboard screen
              Navigator.pushNamed(context, '/Timesheet');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment'),
            onTap: () {
              // Navigate to the dashboard screen
              Navigator.pushNamed(context, '/payment');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text('Expenses'),
            onTap: () {
              // Navigate to the dashboard screen
              Navigator.pushNamed(context, '/expenses');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Navigate to the dashboard screen
              Navigator.pushNamed(context, '/settings');
            },
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text('Logout'),
            onTap: () {
              logout(); // Clear the session or token
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen(),
                ),
              ); // Navigate to the login screen
            },
            // Navigator.pushNamed(context, '/');
            // Navigate to the dashboard screen
          ), // Add more list tiles for other screens as needed
        ],
      ),
    );
  }
}
