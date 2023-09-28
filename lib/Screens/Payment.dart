import 'package:flutter/material.dart';
import 'package:sky_pad/Screens/Viewpayment.dart';

import '../Data_service/Payment_api.dart';
import '../constant/url.dart';
import '../models/Constants.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> payments = [];

  @override
  void initState() {
    super.initState();
    _paymentlist();
  }

  final PaymentApiService apiService =
      PaymentApiService(PAYMENT_LISTVIEW, tokens);

  //**********         API function  (payment view)       *************//
  Future<void> _paymentlist() async {
    final payments = await apiService.paymentview();
    setState(() {
      this.payments = payments;
    });
  }

  //**********         API function  (payment view)       *************//
  // Future<void> _paymentlist() async {
  //   final apiUrl = PAYMENT_LISTVIEW;
  //   final headers = {
  //     'Accept': 'application/json',
  //     'Authorization':
  //         'Bearer $tokens', // Make sure you have 'tokens' defined somewhere
  //   };
  //   try {
  //     final response = await http.get(Uri.parse(apiUrl), headers: headers);
  //     print(response.statusCode);
  //     // print(response.body['leaves']);
  //     // print(response.body[0]);
  //     if (response.statusCode == 200) {
  //       if (response.body.isNotEmpty) {
  //         final responseData = jsonDecode(response.body);
  //         setState(() {
  //           payments = responseData['data'];
  //         });
  //       } else {
  //         setState(() {
  //           payments = []; // Set an empty list to indicate no data
  //         });
  //         print('No payments list available.');
  //       }
  //     } else {
  //       print('Error fetching payment requests: ${response.body}');
  //     }
  //   } catch (error) {
  //     print('Error connecting to the API: $error');
  //   }
  // }
  //**********         API function  (payment view)       *************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintText: "Search",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              onChanged: (text) {
                // Implement your search logic here
                // You can filter your list based on the user's input.
              },
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Container(
              color: Colors.white10,
              child: ListView.builder(
                itemCount:
                    payments.length, // Replace with the actual item count
                itemBuilder: (context, index) {
                  // Replace this with your ListTiles or item widgets
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(payments[index]['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(payments[index]['pdate']),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewPayment(
                                      paymentDetails: payments[index],
                                    ),
                                  ),
                                );
                              },
                              child: Text('View Payment'),
                            ),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            Icon(Icons.currency_rupee),
                            Text(payments[index]['payment']),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
