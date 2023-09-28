import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sky_pad/Screens/showmoreExpenses.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../constant/url.dart';
import '../models/Constants.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<dynamic> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final apiUrl = LIST_EXPENSES;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokens',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        _expenses = responseData['expense'];
      });
    } else {
      print('Error fetching expenses: ${response.body}');
    }
  }

  Widget _buildExpenseList() {
    if (_expenses.isEmpty) {
      return Center(
        child: Text("No expenses found."),
      );
    } else {
      print('2222222222222');
      print(_expenses);
      int count = _expenses.length > 4 ? 4 : _expenses.length;
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: count,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          final name = expense['name'] as String? ?? '';
          final amount = expense['amount'] as String? ?? '';
          final date = expense['date'] as String? ?? '';

          return Container(
            height: 125,
            child: Card(
              margin: EdgeInsets.all(10),
              color: Colors.white12,
              shadowColor: Colors.white10,
              elevation: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.wallet,
                      size: 40.0,
                      color: Colors.blue,
                    ),
                    title: Text(
                      name,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    subtitle: Text(
                      amount,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    trailing: Text(
                      date,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowmoreExpenses(
                              expenseDetails: expense,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.remove_red_eye),
                      color: Colors.orangeAccent,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), // Change the icon here
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Expenses'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 5),
                Text(
                  'Expenses list',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(width: 5.0),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.circle_rounded,
                      color: Colors.red,
                      size: 50,
                    ),
                    Text(
                      _expenses.length.toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15.0),
            totalExpenses(_expenses),
            SizedBox(height: 15.0),
            latestSpendingList(),
            SizedBox(height: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/alltransactions');
                  },
                  child: Text(
                    'Show all Transactions',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                )
              ],
            ),
            _buildExpenseList(),

            // Center(
            //   child: IconButton(
            //     iconSize: 50,
            //     icon: const Icon(Icons.add_circle),
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/addexpenses');
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 56.0, // Set the desired width
        height: 56.0, // Set the desired height
        child: FloatingActionButton(
          elevation: 0.0,
          child: Icon(
            Icons.add,
            size: 30.0,
          ),
          backgroundColor: Color(0xFF0F5EF7),
          onPressed: () {
            Navigator.pushNamed(context, '/addexpenses');
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// Rest of your code

class Expenses {
  final double price;
  final int quantity;

  Expenses(this.price, this.quantity);
}

String returnTotalExpenses(List<dynamic> _expenses) {
  double totalAmount = 0;

  for (int i = 0; i < _expenses.length; i++) {
    final amount = _expenses[i]['amount'];
    if (amount != null) {
      totalAmount += double.parse(amount);
    }
  }

  return totalAmount.toStringAsFixed(2);
}

Widget totalExpenses(List<dynamic> _expenses) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        child: Text(
          'Total Expense',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      SizedBox(height: 20), // Add spacing after the title

      Card(
        color: Colors.white10,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.currency_rupee,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      "${returnTotalExpenses(_expenses)}",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Add the WaveWidget here
            Container(
              height: 50, // Adjust the height of the wave animation
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.blue, Colors.blue.shade200],
                    [Colors.blue.shade200, Colors.blue.shade100],
                  ],
                  durations: [5000, 7000],
                  heightPercentages: [
                    0.2,
                    0.25
                  ], // Adjust the height percentages
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
                ),
                waveAmplitude: 10, // Adjust the wave amplitude
                size: Size(
                    double.infinity, double.infinity), // Full width animation
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget latestSpendingList() {
  return Column(
    mainAxisAlignment:
        MainAxisAlignment.center, // Align children in the center of the column
    children: [
      Text(
        'Latest spending',
        style: TextStyle(fontSize: 25, color: Colors.white),
      )
    ],
  );
}
