import 'package:flutter/material.dart';

class ViewPayment extends StatefulWidget {
  final Map<String, dynamic> paymentDetails;

  const ViewPayment({
    Key? key,
    required this.paymentDetails,
  }) : super(key: key);

  @override
  State<ViewPayment> createState() => _ViewPaymentState();
}

class _ViewPaymentState extends State<ViewPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Payment'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              Text(
                widget.paymentDetails['name'] ?? '',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              SizedBox(height: 5.0),
              Text(
                widget.paymentDetails['contactno'] ?? '',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.attach_money), // Use the correct currency icon
                    SizedBox(width: 10.0),
                    Text(
                      widget.paymentDetails['actual'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 48, // Increase the font size
                        color: Color(0xFF31A8FF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 300,
            margin: EdgeInsets.all(20.0), // Add margin to increase card size
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Text(
                    'Company Name:  ${widget.paymentDetails['company'] ?? ''}',
                    style: TextStyle(fontSize: 20.0),
                  ), // Replace with actual company name
                  Divider(color: Colors.black),
                  SizedBox(height: 10.0), // Increase spacing between items
                  Text(
                    'Payment Id: ${widget.paymentDetails['payment_id'] ?? ''}',
                    style: TextStyle(fontSize: 15.0),
                  ), // Replace with actual payment ID
                  SizedBox(height: 10.0),
                  Text(
                    'Invoice Id: ${widget.paymentDetails['invoice_id'] ?? ''}',
                    style: TextStyle(fontSize: 15.0),
                  ), // Replace with actual invoice ID
                  SizedBox(height: 10.0),
                  Text(
                    'Email: ${widget.paymentDetails['email'] ?? ''}',
                    style: TextStyle(fontSize: 15.0),
                  ), // Replace with actual email
                  SizedBox(height: 10.0),
                  Text(
                    'Actual Payment: ${widget.paymentDetails['actual'] ?? ''}',
                    style: TextStyle(fontSize: 15.0),
                  ), // Replace with actual payment amount
                  SizedBox(height: 10.0),
                  Text(
                    'Last Paid: ${widget.paymentDetails['payment'] ?? ''}',
                    style: TextStyle(fontSize: 15.0),
                  ), // Replace with actual last paid date
                  SizedBox(height: 10.0),
                  Text(
                    'Paid Date:  ${widget.paymentDetails['pdate'] ?? ''}',
                    style: TextStyle(fontSize: 15.0),
                  ), // Replace with actual paid date
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
