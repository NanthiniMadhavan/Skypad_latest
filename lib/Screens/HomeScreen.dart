import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sky_pad/Screens/Drawer.dart';
import 'package:sky_pad/constant/url.dart';

import '../models/Constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Map<String, dynamic> _profile = {};
  var _profileimage;
  var _image;
  @override
  void initState() {
    super.initState();

    fetchtoken();
    _loadprofile();
  }
  //
  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }

  Future<void> _loadprofile() async {
    final apiUrl =
        PROFILE; // Replace with your Laravel API endpoint URL to fetch profile
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokens',
      },
    );
    print('Response Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Profile successfully fetched
      Map<String, dynamic> responseData = jsonDecode(response.body);

      print('Response Body: ${responseData['data']}');

      setState(() {
        _profile = responseData['data'];
        _profileimage = _profile['profile_photo_path'];

        // Check if the profile image URL is valid
        if (_profileimage != null && _profileimage.isNotEmpty) {
          _image = '$PROFILE_IMAGE/$_profileimage';
        } else {
          // Set a default image URL or handle this case as needed
          _image = 'assets/images/Pro.png';
        }
      });
    } else {
      // Handle error
      print('Error fetching profile details: ${response.body}');
      // You may want to set a default image URL here as well
    }
  }

  final List<IconData> iconsList = [
    Icons.pie_chart,
    Icons.calendar_today,
    Icons.watch_later,
    Icons.payment,
    Icons.account_balance_wallet,
    Icons.settings,
    // Add more icons as needed
  ];

  final List<String> namelist = [
    // Button list
    "Dashboard",
    "Leaves",
    "Time sheet",
    "Payment",
    "Expenses",
    "Settings",
  ];

  // List color = [
  //   Color(0xFF5C7AEA),
  //   Color(0xFFC0C0C0),
  //   // Color(0xFFCCBA78),
  //   // Color(0xFFB9F2FF),
  //   Color(0xFFC0C0C0),
  //   Color(0xFF5C7AEA),
  //   Color(0xFFCD7F32),
  //   Color(0xFFC0C0C0),
  // ];

  // List buttonclor = [
  //   Color(0xFFC0C0C0),
  //   Color(0xFFCD7F32),
  //   Color(0xFFCD7F32),
  //   Color(0xFFC0C0C0),
  //   Color(0xFFC0C0C0),
  //   Color(0xFFCD7F32),
  // ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        // Navigator.pushNamed(context, '/home');
        // Home screen
        break;
      case 1:
        // Search screen
        break;
      case 2:
        // Profile screen
        Navigator.pushNamed(context, '/profile');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              // color: Color(0xFF76D7EA),
              padding: EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: _image != null
                          ? NetworkImage(_image!)
                          : AssetImage('assets/images/Pro.png')
                              as ImageProvider<Object>,
                      // child: Image.network(
                      //   ,
                      //   errorBuilder: (BuildContext context, Object exception,
                      //       StackTrace? stackTrace) {
                      //     return Image.asset(
                      //       'assets/images/Pro.png',
                      //     );
                      //   },
                      // ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.0),
                      Text(
                        'Hi,',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        _profile['name'] ?? '',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Open the drawer when the icon is tapped
                      _scaffoldKey.currentState?.openEndDrawer();
                      // Navigator.pushNamed(context, '/drawer');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.menu,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              // Use custom clipper

              child: Card(
                  elevation: 10.0,
                  color: Colors.white10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0.0,
                        mainAxisSpacing: 0.0,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: iconsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (iconsList[index] == Icons.pie_chart) {
                                    Navigator.pushNamed(context, '/dashboard');
                                  } else if (iconsList[index] ==
                                      Icons.calendar_today) {
                                    Navigator.pushNamed(context, '/leaves');
                                  } else if (iconsList[index] ==
                                      Icons.watch_later) {
                                    Navigator.pushNamed(context, '/Timesheet');
                                    // Handle time sheet screen
                                  } else if (iconsList[index] ==
                                      Icons.payment) {
                                    Navigator.pushNamed(context, '/payment');
                                    // Handle payment screen
                                  } else if (iconsList[index] ==
                                      Icons.account_balance_wallet) {
                                    // Handle expenses screen
                                    Navigator.pushNamed(context, '/expenses');
                                  } else if (iconsList[index] ==
                                      Icons.settings) {
                                    // Handle settings screen
                                    Navigator.pushNamed(context, '/settings');
                                  }
                                });
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                child: Icon(
                                  iconsList[index],
                                  size: 40.0,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 27, 28, 30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      spreadRadius: 5,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 6.0),
                            // Button Section
                            // Container(
                            //   decoration: BoxDecoration(
                            //     boxShadow: [
                            //       BoxShadow(
                            //         color: Colors.grey.withOpacity(0.5), // Shadow color
                            //         spreadRadius: 2,
                            //         blurRadius: 5,
                            //         offset: Offset(0, 3), // Offset for shadow
                            //       ),
                            //     ],
                            //   ),
                            // child: ElevatedButton(
                            //   onPressed: () {
                            //     if (namelist[index] == 'Dashboard') {
                            //       Navigator.pushNamed(context, '/dashboard');
                            //     } else if (namelist[index] == 'Leaves') {
                            //       Navigator.pushNamed(context, '/leaves');
                            //     } else if (namelist[index] == 'Time sheet') {
                            //       Navigator.pushNamed(context, '/Timesheet');
                            //     } else if (namelist[index] == 'Payment') {
                            //       Navigator.pushNamed(context, '/payment');
                            //     } else if (namelist[index] == 'Expenses') {
                            //       Navigator.pushNamed(context, '/expenses');
                            //     } else if (namelist[index] == 'Settings') {
                            //       Navigator.pushNamed(context, '/settings');
                            //     }
                            //   },
                            //   style: ButtonStyle(
                            //     backgroundColor:
                            //         MaterialStateProperty.all<Color>(Colors.white),
                            //
                            //   ),
                            //   child: Text(
                            //     namelist[index],
                            //     style: TextStyle(color: Colors.black),
                            //   ),
                            // ),

                            Text(
                              namelist[index],
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        );
                      },
                    ),
                  )),
            ),
            Center(
              child: CurvedNavigationBar(
                backgroundColor: Colors.white,
                color: Color(0xFF000000),
                items: <Widget>[
                  Icon(
                    Icons.home,
                    size: 30,
                  ),
                  Icon(
                    Icons.search,
                    size: 30,
                  ),
                  Icon(
                    Icons.person,
                    size: 30,
                  ),
                ],
                onTap: _onItemTapped,
                index: _selectedIndex,
              ),
            ),
          ],
        ),
      ),
      key: _scaffoldKey,
      endDrawer: CustomAppdrawer(),
    );
  }
}
