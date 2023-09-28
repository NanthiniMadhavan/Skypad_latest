import 'package:flutter/material.dart';
import 'package:sky_pad/Screens/EditProfileScreen.dart';

import '../Data_service/Profile_api.dart';
import '../constant/url.dart';
import '../models/Constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Map<String, dynamic> _profile = {};
  // Create TextEditingControllers
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _empIdController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  var _profileimage;
  var _image;
  @override
  void initState() {
    super.initState();

    // fetchtoken();
    _loadprofile();
  }

  Future<void> _loadprofile() async {
    try {
      final profileData =
          await ProfileApi.fetchProfile(tokens); // Pass your tokens here

      setState(() {
        _profile = profileData;
        _profileimage = _profile['profile_photo_path'];

        if (_profileimage != null && _profileimage.isNotEmpty) {
          _image = '$PROFILE_IMAGE/$_profileimage';
        } else {
          _image = 'assets/images/Pro.png';
        }
      });
    } catch (error) {
      // Handle any errors that occur during the API request
      print('Error loading profile: $error');
      // You may want to set a default image URL here as well
    }
  }

  // ***** api function **** //

  //
  // Future<void> _loadprofile() async {
  //   final apiUrl =
  //       PROFILE; // Replace with your Laravel API endpoint URL to fetch profile
  //   final response = await http.get(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $tokens',
  //     },
  //   );
  //   print('Response Status Code: ${response.statusCode}');
  //
  //   if (response.statusCode == 200) {
  //     // Profile successfully fetched
  //     Map<String, dynamic> responseData = jsonDecode(response.body);
  //
  //     print('Response Body: ${responseData['data']}');
  //
  //     setState(() {
  //       _profile = responseData['data'];
  //       _profileimage = _profile['profile_photo_path'];
  //
  //       // Check if the profile image URL is valid
  //       if (_profileimage != null && _profileimage.isNotEmpty) {
  //         _image = '$PROFILE_IMAGE/$_profileimage';
  //       } else {
  //         // Set a default image URL or handle this case as needed
  //         _image = 'assets/images/Pro.png';
  //       }
  //     });
  //   } else {
  //     // Handle error
  //     print('Error fetching profile details: ${response.body}');
  //     // You may want to set a default image URL here as well
  //   }
  // }

  //**** api function ***** //

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return Scaffold(
        backgroundColor: Color(0xFF001E36),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      print(_image);
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Profile'),
          backgroundColor: Color(0XFF263238),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: _image != null
                    ? NetworkImage(_image!)
                    : AssetImage('assets/images/Pro.png')
                        as ImageProvider<Object>,
                // child: Image.network(
                //   _image ?? '',
                //   width: 120,
                //   height: 120,
                //   fit: BoxFit.cover,
                //   errorBuilder: (BuildContext context, Object exception,
                //       StackTrace? stackTrace) {
                //     return Image.asset(
                //       'assets/images/Pro.png',
                //       width: 120,
                //       height: 120,
                //       fit: BoxFit.cover,
                //     );
                //   },
                // ),
              ),

              // CircleAvatar(
              //   radius: 60,
              //   // Add your avatar image here
              //   backgroundImage: AssetImage('assets/images/Pro.png'),
              // ),
              SizedBox(height: 20),
              Text(
                _profile['emp_id'] ?? '',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                _profile['name'] ?? '',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.blue.shade400,
                ),
                title: Text(
                  _profile['email'] ?? '',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.phone,
                  color: Colors.blue.shade400,
                ),
                title: Text(
                  _profile['phone'] ?? '',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfleScreen(
                          profileDetails: {
                            'name': _profile['emp_id'],
                            'email': _profile['email'],
                            'emp_id': _profile['name'],
                            'phone': _profile['phone'],
                            'profile_photo_path': _profileimage,
                          },
                          profileImageUrl: _image,
                        ),
                      ),
                    );
                  },
                  child: Text('Edit Profile'))
            ],
          ),
        ),
      );
    }
  }
}
