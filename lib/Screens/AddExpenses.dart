import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/url.dart';
import '../models/Constants.dart';

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  bool _isgst = false;

  String successMessage = ''; // State to hold success message
  // Controller for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _spentByController = TextEditingController();
  final TextEditingController _modeOfPaymentController =
      TextEditingController();

  bool _isDatePickerOpen = false;
  String dropdownValue = "-Asset";
  // var tokens;
  String name = '';
  String categories = '';
  String subCategories = '';
  var date = '';
  String location = '';
  var amount = '';
  String spent_by = '';
  String modeOfPayment = '';
  var gst = '';

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
    "-MAINTENANCE",
    'Plumbing',
    'Camera Accessories',
    'laptop/computer',
    'Others',
    "-SALARY",
    'Freelancing Payment',
    'Support Staff',
    'Employee-Technology',
    'Employee-Studio',
    'Others',
    "-TRANSPORT",
    'Fuel',
    'Bus/train',
    'Toll',
    'Others',
    "-LOGISTICS",
    'Stationary',
    'Cleaning',
    'Others',
    "-FOOD",
    'Food',
    'Tea & Snacks',
    'Water',
    'Others',
    "-CUSTOMER",
    'Print',
    'frame',
    'Domain',
    'Hosting',
    'Others',
    "-MARKETING",
    'Technology',
    'Creative Service',
    'Academy',
    'Others',
    "-OPERATION",
    'Electricity Bill',
    'Internet Bill',
    'Subscription',
    'Others'
  ];

  final List<String> payment = ['CASH', 'CARD', 'UPI', 'BANK', 'CHEQUE'];

  void initState() {
    super.initState();
    print(tokens);
    fetchtoken();

    _dateController.text = "";
    // _categoryController.text = ''; //set the initial value of text field
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

  actionGST(bool value) {
    _isgst = value;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool('gst', value);
      },
    );
    setState(() {
      _isgst = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTextField(_nameController, 'Expense Name', iconlist[0]),
              _buildTextField(_categoryController, 'Categories', iconlist[1]),
              _buildTextField(
                  _subCategoryController, 'Sub Category', iconlist[2]),
              _buildTextField(_dateController, 'Date', iconlist[3]),
              _buildTextField(_locationController, 'Location', iconlist[4]),
              _buildTextField(_amountController, 'Amount', iconlist[5]),
              _buildTextField(_spentByController, 'Spent By', iconlist[6]),
              _buildTextField(
                  _modeOfPaymentController, 'Mode of Payments', iconlist[7]),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    side: BorderSide(color: Theme.of(context).hintColor),
                    value: _isgst,
                    checkColor: Theme.of(context).primaryColor,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isgst = newValue ?? false;
                      });
                    },
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text('GST',
                      style: TextStyle(color: Theme.of(context).hintColor)),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveExpenses();
                },
                child: Text('Save'),
              ),
              if (successMessage.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 14.0),
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF006A6E),
                    borderRadius:
                        BorderRadius.circular(8.0), // Add rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3), // Add shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      successMessage,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData iconlist) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        style: TextStyle(color: Color(0xFF31A8FF)),
        textAlign: TextAlign.left,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: () {
              if (iconlist == Icons.calendar_month) {
                _showDatePicker();
              } else if (iconlist == Icons.arrow_drop_down_circle) {
                FocusScope.of(context).unfocus(); // Close keyboard
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return _cdropdown(); // Show the dropdown
                  },
                );
              } else if (iconlist == Icons.arrow_drop_down_circle_rounded) {
                FocusScope.of(context).unfocus(); // Close keyboard
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return _scdropdown(); // Show the dropdown
                  },
                );
              } else if (iconlist == Icons.arrow_drop_down_circle_sharp) {
                FocusScope.of(context).unfocus(); // Close keyboard
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return _mpdropdown(); // Show the dropdown
                  },
                );
              }
            },
            child: Icon(
              iconlist,
              color: Colors.white,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white, // Set the border color here
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
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
          color: Colors.lightBlueAccent,
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
      color: Colors.lightBlueAccent,
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
          color: Colors.lightBlueAccent,
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
          color: Colors.lightBlueAccent,
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

  Future<void> _saveExpenses() async {
    String name = _nameController.text;
    String categories = _categoryController.text;
    String subCategories = _subCategoryController.text;
    String date = _dateController.text;
    String location = _locationController.text;
    String amount = _amountController.text;
    String spent_by = _spentByController.text;
    String modeOfPayment = _modeOfPaymentController.text;

    final apiUrl = ADD_EXPENSES; // Replace with your Laravel API endpoint URL

    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokens',
    }, body: {
      'name': name,
      'date': date,
      'categories': categories,
      'sub_categories': subCategories,
      'location': location,
      'description': 'description',
      'amount': amount,
      'spent_by': spent_by,
      'payments': modeOfPayment,
      'gst': modeOfPayment,
    });

    // if (response.statusCode == 200) {
    //   // Expense successfully added
    //   print('Expense added!');
    // }
    if (response.statusCode == 200) {
      // Expense successfully added
      setState(() {
        successMessage = 'Expense added successfully!'; // Set success message
        // Clear input fields
        _nameController.clear();
        _categoryController.clear();
        _subCategoryController.clear();
        _dateController.clear();
        _locationController.clear();
        _amountController.clear();
        _spentByController.clear();
        _modeOfPaymentController.clear();
      });
      print('Expense added!');

      // Show success message for 3 seconds and then clear it
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        successMessage = ''; // Clear success message
      });
      // Show a snackbar with the success message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Expense added successfully!'),
      //     duration: Duration(seconds: 3), // Duration for the snackbar
      //   ),
      // );
    } else {
      // Handle error
      print('Error adding expense: ${response.body}');
    }
  }
}
