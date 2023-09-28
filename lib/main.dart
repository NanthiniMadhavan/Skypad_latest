import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_pad/Screens/AddExpenses.dart';
import 'package:sky_pad/Screens/AddLeave.dart';
import 'package:sky_pad/Screens/AddTimesheet.dart';
import 'package:sky_pad/Screens/Dashboard.dart';
import 'package:sky_pad/Screens/Drawer.dart';
import 'package:sky_pad/Screens/EditExpense.dart';
import 'package:sky_pad/Screens/Forget_password.dart';
import 'package:sky_pad/Screens/HomeScreen.dart';
import 'package:sky_pad/Screens/Leaves.dart';
import 'package:sky_pad/Screens/LoginScreen.dart';
import 'package:sky_pad/Screens/Payment.dart';
import 'package:sky_pad/Screens/ProfileScreen.dart';
import 'package:sky_pad/Screens/Reset_Password.dart';
import 'package:sky_pad/Screens/Settings.dart';
import 'package:sky_pad/Screens/Timesheet.dart';
import 'package:sky_pad/Screens/WelcomeScreen.dart';
import 'package:sky_pad/Screens/verify.dart';
import 'package:sky_pad/models/Thememodel.dart';

import 'Screens/AllTransactions.dart';
import 'Screens/Expenses.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (BuildContext context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Initialize the Math application
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //disable the debug banner
      theme: Provider.of<ThemeProvider>(context).currentTheme,

      // theme: ThemeData(scaffoldBackgroundColor: Color(0xFF001E36)),
      //set the theme of the app
      initialRoute: '/',
      //set the initial route
      routes: {
        '/': (context) =>
            WelcomeScreen(), //define the route for the welcome Screen
        '/login': (context) => LoginScreen(),
        '/forgetpassword': (context) => ForgetPassword(),
        'verify': (context) => Verify(),
        '/reset': (context) => ResetPassword(),
        '/home': (context) => HomeScreen(),

        '/leaves': (context) => LeaveRequestsPage(),
        '/addleave': (context) => Addleave(),
        '/Timesheet': (context) => Timesheetview(),
        '/addTimesheet': (context) => Addtimesheet(),
        // '/AddTimesheet': (context) => Addtimesheet(
        //       onAddTask: (List<Task> tasks) {
        //         // Handle the added tasks here if needed
        //         // For example, you can update the state in the parent widget.
        //       },
        //     ),

        '/expenses': (context) => ExpensesPage(
            // expenses: const [],
            ),
        '/addexpenses': (context) => AddExpensePage(),
        '/editexpense': (context) => EditExpense(
              expenseDetails: {},
            ),
        '/profile': (context) => ProfileScreen(),
        // '/editprofile': (context) => EditProfleScreen(
        //
        //     ),
        '/dashboard': (context) => DashboardScreen(
              tasks: [],
            ),
        // '/showmore': (context) => ShowmoreExpenses(
        //       expenseDetails: _expenses[index],
        //     ),
        '/alltransactions': (context) => AllTransactions(),
        '/payment': (context) => Payment(),
        // '/view Payment': (context) => ViewPayment(
        //       paymentDetails: {},
        //     ),
        '/settings': (context) => Settings(),
        '/drawer': (context) => CustomAppdrawer(),
      },
    );
  }
}
