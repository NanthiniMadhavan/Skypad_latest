import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constant/url.dart';
import '../models/Constants.dart';

class EditExpense extends StatefulWidget {
  final Map<String, dynamic> expenseDetails;

  const EditExpense({Key? key, required this.expenseDetails}) : super(key: key);

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  bool _isDatePickerOpen = false;
  final List<IconData> iconlist = [
    Icons.wallet,
    Icons.arrow_drop_down_circle,
    Icons.arrow_drop_down_circle_rounded,
    Icons.calendar_month,
    Icons.location_on_sharp,
    Icons.attach_money,
    Icons.person,
    Icons.arrow_drop_down_circle_sharp,
  ];
  final List<String> categoryItems = [
    '-ASSET',
    '-MAINTENANCE',
    '-SALARY',
    '-TRANSPORT',
    '-LOGISTICS',
    '-FOOD',
    '-CUSTOMER',
    '-MARKETING',
    'OPERATION'
  ];

  final List<String> submenuItems = [
    '-ASSET',
    'Electrical',
    'Electronics',
    'Computer Accessories',
    'Furniture',
    'Building Infrastructure',
    'laptop/computer',
    'Advances',
    'Others',
    "-MAINTENANCE"
        'Plumbing',
    'Camera Accessories',
    'laptop/computer',
    'Others',
    "-SALARY"
        'Freelancing Payment',
    'Support Staff',
    'Employee-Technology',
    'Employee-Studio',
    'Others',
    "-TRANSPORT" 'Fuel',
    'Bus/train',
    'Toll',
    'Others',
    "-LOGISTICS"
        'Stationary',
    'Cleaning',
    'Others',
    "-FOOD"
        'Food',
    'Tea & Snacks',
    'Water',
    'Others',
    "-CUSTOMER"
        'Print',
    'frame',
    'Domain',
    'Hosting',
    'Others',
    "-MARKETING"
        'Technology',
    'Creative Service',
    'Academy',
    'Others',
    "-OPERATION"
        'Electricity Bill',
    'Internet Bill',
    'Subscription',
    'Others'
  ];

  final List<String> payment = ['CASH', 'CARD', 'UPI', 'BANK', 'CHEQUE'];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _spentByController = TextEditingController();
  final TextEditingController _modeOfPaymentController =
      TextEditingController();
  final TextEditingController _idController = TextEditingController();
  // int selectedIndex = -1;
  @override
  void initState() {
    super.initState();

    // Initialize controllers with data from the expenseDetails

    _nameController.text = widget.expenseDetails['name'] ?? '';
    _categoryController.text = widget.expenseDetails['categories'] ?? '';
    _subCategoryController.text = widget.expenseDetails['sub_categories'] ?? '';
    _dateController.text = widget.expenseDetails['date'] ?? '';
    _locationController.text = widget.expenseDetails['location'] ?? '';
    _amountController.text = widget.expenseDetails['amount'] ?? '';
    _spentByController.text = widget.expenseDetails['spent_by'] ?? '';
    _modeOfPaymentController.text = widget.expenseDetails['payments'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _subCategoryController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _amountController.dispose();
    _spentByController.dispose();
    _modeOfPaymentController.dispose();
    super.dispose();
  }

  Future<void> _updateExpense() async {
    String name = _nameController.text;
    String categories = _categoryController.text;
    String subCategories = _subCategoryController.text;
    String date = _dateController.text;
    String location = _locationController.text;
    String amount = _amountController.text;
    String spent_by = _spentByController.text;
    String modeOfPayment = _modeOfPaymentController.text;
    final apiUrl = EXPENSEUPDATE; // Replace with your API endpoint

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokens',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': widget.expenseDetails['id'], // Include the expense ID
          'name': name,
          'date': date,
          'categories': categories,
          'sub_categories': subCategories,
          'location': location,
          // 'description': 'description',
          'amount': amount,
          'spent_by': spent_by,
          'payments': modeOfPayment,
          // 'gst': modeOfPayment,
          // Add other updated fields here
        }),
      );
      print(widget.expenseDetails['id']);
      print(name);
      print(date);
      print(categories);
      print(subCategories);
      print(location);
      if (response.statusCode == 200) {
        // Expense updated successfully
        print('Expense updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Expense updated successfully')),
        );

        // Navigator.pop(context, true); // Return true to indicate success
      } else {
        // Handle API errors
        // You can show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update the expense.')),
        );
      }
    } catch (error) {
      // Handle network errors
      print('Error updating expense: $error');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData? icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        style: TextStyle(color: Color(0xFF31A8FF)),
        textAlign: TextAlign.left,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: icon != null
              ? InkWell(
                  onTap: () {
                    if (icon == Icons.calendar_today) {
                      _showDatePicker();
                    } else if (icon == Icons.arrow_drop_down_circle) {
                      FocusScope.of(context).unfocus();
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return _cdropdown();
                        },
                      );
                    } else if (icon == Icons.arrow_drop_down_circle_sharp) {
                      FocusScope.of(context).unfocus();
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return _scdropdown();
                        },
                      );
                    } else if (icon == Icons.payment) {
                      FocusScope.of(context).unfocus();
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return _mpdropdown();
                        },
                      );
                    }
                  },
                  child: Icon(
                    icon,
                    color: Color(0xFF31A8FF),
                  ),
                )
              : null,
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF31A8FF)),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _cdropdown() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _dropdownHeader(),
        Container(
          height: 200,
          child: ListView(
            children: <Widget>[
              for (String category in categoryItems)
                ListTile(
                  title: Text(category),
                  onTap: () {
                    setState(() {
                      _categoryController.text = category;
                    });
                    Navigator.pop(context); // Close the dropdown
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dropdownHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Select a category',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _scdropdown() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _dropdownHeader(),
        Container(
          height: 200,
          child: ListView(
            children: <Widget>[
              for (String subcategory in submenuItems)
                ListTile(
                  title: Text(subcategory),
                  onTap: () {
                    setState(() {
                      _subCategoryController.text = subcategory;
                    });
                    Navigator.pop(context); // Close the dropdown
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mpdropdown() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _dropdownHeader(),
        Container(
          height: 200,
          child: ListView(
            children: <Widget>[
              for (String modeOfPayment in payment)
                ListTile(
                  title: Text(modeOfPayment),
                  onTap: () {
                    setState(() {
                      _modeOfPaymentController.text = modeOfPayment;
                    });
                    Navigator.pop(context); // Close the dropdown
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker() async {
    setState(() {
      _isDatePickerOpen = true;
    });
    // Call your function to open date picker here
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      print(
          formattedDate); //formatted date output using intl package =>  2021-03-16
      setState(() {
        _dateController.text =
            formattedDate; //set output date to TextField value.
      });
    } else {}
    ;
    setState(() {
      _isDatePickerOpen = false;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Edit Expense'),
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           TextFormField(
  //             controller: _nameController,
  //             decoration: InputDecoration(labelText: 'Name'),
  //           ),
  //           SizedBox(
  //             height: 20.0,
  //           ),
  //           TextFormField(
  //             controller: _categoryController,
  //             decoration: InputDecoration(labelText: 'Category'),
  //           ),
  //           SizedBox(
  //             height: 20.0,
  //           ),
  //           TextFormField(
  //             controller: _subCategoryController,
  //             decoration: InputDecoration(labelText: 'Sub-category'),
  //           ),
  //           SizedBox(
  //             height: 20.0,
  //           ),
  //           TextFormField(
  //             controller: _dateController,
  //             decoration: InputDecoration(labelText: 'Date'),
  //           ),
  //           SizedBox(
  //             height: 20.0,
  //           ),
  //           TextFormField(
  //             controller: _locationController,
  //             decoration: InputDecoration(labelText: 'Location'),
  //           ),
  //           SizedBox(
  //             height: 20.0,
  //           ),
  //           TextFormField(
  //             controller: _amountController,
  //             decoration: InputDecoration(labelText: 'Amount'),
  //           ),
  //           SizedBox(
  //             height: 20.0,
  //           ),
  //           TextFormField(
  //             controller: _spentByController,
  //             decoration: InputDecoration(labelText: 'Spent By'),
  //           ),
  //           SizedBox(
  //             height: 20.0,
  //           ),
  //           TextFormField(
  //             controller: _modeOfPaymentController,
  //             decoration: InputDecoration(labelText: 'Mode of Payment'),
  //           ),
  //           SizedBox(
  //             height: 20.0,
  //           ),
  //           SizedBox(
  //             height: 20,
  //           ),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              _nameController,
              'Name',
              null,
            ),
            _buildTextField(
                _categoryController, 'Category', Icons.arrow_drop_down_circle),
            _buildTextField(_subCategoryController, 'Sub-category',
                Icons.arrow_drop_down_circle_sharp),
            _buildTextField(_dateController, 'Date', Icons.calendar_today),
            _buildTextField(_locationController, 'Location', null),
            _buildTextField(_amountController, 'Amount', null),
            _buildTextField(_spentByController, 'Spent By', null),
            _buildTextField(
                _modeOfPaymentController, 'Mode of Payment', Icons.payment),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () async {
                widget.expenseDetails['name'] = _nameController.text;

                widget.expenseDetails['categories'] = _categoryController.text;
                widget.expenseDetails['sub_categories'] =
                    _subCategoryController.text;
                widget.expenseDetails['date'] = _dateController.text;
                widget.expenseDetails['location'] = _locationController.text;
                widget.expenseDetails['amount'] = _amountController.text;
                widget.expenseDetails['spent_by'] = _spentByController.text;
                widget.expenseDetails['payments'] =
                    _modeOfPaymentController.text;
                await _updateExpense();
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
