import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sky_pad/Screens/showmoreExpenses.dart';

import '../constant/url.dart';
import '../models/Constants.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({Key? key}) : super(key: key);

  @override
  State<AllTransactions> createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  List<List<dynamic>> _expensesPages =
  []; // List of pages, each containing data
  int currentPage = 0; // Current page index

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
      List<dynamic> expenses = responseData['expense'];

      _expensesPages.clear(); // Clear the existing pages

      int pageSize = 12; // Number of items per page

      for (int i = 0; i < expenses.length; i += pageSize) {
        // Calculate the end index for the sublist
        int endIndex = (i + pageSize <= expenses.length)
            ? (i + pageSize)
            : expenses.length;
        _expensesPages.add(expenses.sublist(i, endIndex));
      }

      setState(() {
        currentPage = 0; // Set initial page to 0
      });
    } else {
      print('Error fetching expenses: ${response.body}');
    }
  }

  void goToPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> currentPageData =
    _expensesPages.isEmpty ? [] : _expensesPages[currentPage];
    ; // Get data for current page
    return Scaffold(
      appBar: AppBar(
        title: Text('All Transactions'),
        actions: [
          IconButton(
            onPressed: () {
              // method to show the search bar
              // showSearch(
              //   context: context,
              //   delegate: CustomSearchDelegate();
              // );
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              border: TableBorder.all(width: 1, color: Color(0xFF006A6E)),
              headingRowColor:
              MaterialStateColor.resolveWith((states) => Color(0xFF006A6E)),
              columns: [
                DataColumn(
                  label: Text('Name',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                DataColumn(
                  label: Text('Date',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                DataColumn(
                  label: Text('Details',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
              rows: currentPageData.isNotEmpty
                  ? currentPageData.map((expense) {
                return DataRow(cells: [
                  DataCell(Text(
                    expense['name'],
                    style: TextStyle(color: Colors.white),
                  )),
                  DataCell(Text(
                    expense['date'],
                    style: TextStyle(color: Colors.white),
                  )),
                  DataCell(IconButton(
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
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.orangeAccent,
                    ),
                  )),
                ]);
              }).toList()
                  : [], // If _expenses is empty, return an empty list for rows
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('prev',
                  style: TextStyle(
                      color: Color(0xFF006A6E),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              IconButton(
                onPressed: currentPage > 0
                    ? () {
                  goToPage(currentPage - 1);
                }
                    : null,
                icon: Icon(
                  Icons.skip_previous_outlined,
                  size: 20.0,
                  color: currentPage > 0 ? Color(0xFF006A6E) : Colors.grey,
                ),
                // color: Colors.grey,
              ),
              SizedBox(width: 10),
              Text('next',
                  style: TextStyle(
                      color: Color(0xFF006A6E),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              IconButton(
                onPressed: currentPage < _expensesPages.length - 1
                    ? () {
                  goToPage(currentPage + 1);
                }
                    : null,
                icon: Icon(
                  Icons.skip_next_outlined,
                  size: 20.0,
                  color: currentPage < _expensesPages.length - 1
                      ? Color(0xFF006A6E)
                      : Colors.grey,
                ),
                // color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<String> nameList;

  CustomSearchDelegate(this.nameList);

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Clear query button in the app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // Close the search bar and return to the previous screen
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Handle the search results
    final List<String> searchResults = nameList
        .where((name) => name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]),
          onTap: () {
            // You can navigate to the details screen here if needed
            // For now, let's just close the search and display the selected name
            close(context, searchResults[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions displayed when the user types in the search bar
    final List<String> suggestionList = nameList
        .where((name) => name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            // Set the selected suggestion as the query text
            query = suggestionList[index];
          },
        );
      },
    );
  }
}
