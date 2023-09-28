import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../constant/url.dart';
import '../models/Constants.dart';

class EditProfleScreen extends StatefulWidget {
  final Map<String, dynamic> profileDetails;
  final String? profileImageUrl;
  const EditProfleScreen(
      {Key? key, required this.profileDetails, this.profileImageUrl})
      : super(key: key);

  @override
  State<EditProfleScreen> createState() => _EditProfleScreenState();
}

class _EditProfleScreenState extends State<EditProfleScreen> {
  late Map<String, dynamic> _profile = {};
  File? _imageFile;
  String successMessage = '';
  var _profileimage;
  var _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  String? _imageURL; // Add this line to store the image URL
  void initState() {
    super.initState();

    _nameController.text = widget.profileDetails['name'] ?? '';
    _mailController.text = widget.profileDetails['email'] ?? '';
    _idController.text = widget.profileDetails['emp_id'] ?? '';
    _imageURL = widget
        .profileImageUrl; // Initialize _imageFile with the provided image URL
  }

  // void dipose() {
  //   _nameController.dispose();
  //   _mailController.dispose();
  //   _idController.dispose();
  //   // _phoneController.dispose();
  //
  //   super.dispose();
  // }

  // Future<void> _getImage() async {
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           "Choose an option",
  //           style: TextStyle(color: Colors.black),
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               GestureDetector(
  //                 child: Text("Gallery"),
  //                 onTap: () async {
  //                   Navigator.of(context).pop();
  //                   await _getImageFromGallery();
  //                 },
  //               ),
  //               Padding(padding: EdgeInsets.all(10.0)),
  //               GestureDetector(
  //                 child: Text("Camera"),
  //                 onTap: () async {
  //                   Navigator.of(context).pop();
  //                   await _getImageFromCamera();
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> _getImage() async {
    if (kIsWeb) {
      // On web platform
      final html.FileUploadInputElement input = html.FileUploadInputElement()
        ..accept = 'image/*'; // Accept any image type
      input.click();

      input.onChange.listen((e) {
        final files = input.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();
          reader.readAsDataUrl(file);

          reader.onLoadEnd.listen((e) {
            setState(() {
              _imageURL = reader.result as String?;
            });
          });
        }
      });
    } else {
      // On mobile platform
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose an option",
              style: TextStyle(color: Colors.black),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await _getImageFromGallery();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await _getImageFromCamera();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        _imageURL = _imageFile?.path; // Update _imageURL with the file path
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageURL = _imageFile?.path;
      });
    }
  }

// **** edit profile api ***** //
  Future<void> _updateprofile() async {
    final apiUrl = EDIT_PROFILE;

    Map<String, dynamic> requestBody = {
      'name': _nameController.text,
      'email': _mailController.text,
      'emp_id': _idController.text,
      'profile_photo_path': _imageFile != null
          ? base64Encode(_imageFile!.readAsBytesSync())
          : null,
    };

    try {
      if (!mounted) {
        return;
      }

      print('Request Body: $requestBody');
      final response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokens',
          'Accept': 'application/json',
        },
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (!mounted) {
        return;
      }
      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          successMessage = 'Profile updated successfully!';
          _nameController.clear();
          _mailController.clear();
          _idController.clear();
        });

        // Update the background image if a new image is selected
        if (_imageFile != null) {
          setState(() {
            _imageURL = _imageFile!.path;
          });
        }

        Navigator.of(context).pop();

        await Future.delayed(Duration(seconds: 5));
        setState(() {
          successMessage = '';
        });
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      if (mounted) {
        print('Error updating profile: $error');
      }
    }
  }

// **** edit profile api ***** //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Color(0XFF263238),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: ListView(
          children: <Widget>[
            // Imageprofile(),
            // OutlineButton(onPressed: getImage, child: _buildImage()),
            Center(
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    // backgroundImage: _imageURL != null
                    //     ? NetworkImage(_imageURL!) // Use the provided image URL
                    //     : AssetImage('assets/images/Pro.png')
                    //         as ImageProvider<Object>,
                    backgroundImage: _imageURL != null
                        ? NetworkImage(_imageURL!)
                        : AssetImage('assets/images/Pro.png')
                            as ImageProvider<Object>,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 15,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Color(0xFF5C7AEA),
                        size: 28.0,
                      ),
                      onPressed: () {
                        _getImage();
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            nameTextfield(_idController),
            SizedBox(
              height: 20,
            ),
            employeefield(_nameController),
            SizedBox(
              height: 20,
            ),
            emailfield(_mailController),
            SizedBox(
              height: 20,
            ),
            // phonefield(_phoneController),
            // SizedBox(
            //   height: 20,
            // ),
            // buttonfield(),
            Center(
              child: Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueAccent),
                  ),
                  onPressed: () {
                    _updateprofile();
                  },
                  child: Text('Submit'),
                ),
              ),
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
    );
  }
}

Widget nameTextfield(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF5C7AEA)),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Color(0xFF5C7AEA),
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Color(0xFF5C7AEA),
        ),
        labelText: "Name",
        labelStyle: TextStyle(color: Color(0xFF5C7AEA)),
        helperText: "Name can't be empty",
        helperStyle: TextStyle(color: Color(0xFF5C7AEA)),
        hintText: 'Name',
        hintStyle: TextStyle(color: Colors.grey)),
  );
}

Widget employeefield(TextEditingController controller) {
  return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF5C7AEA)),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Color(0xFF5C7AEA),
            width: 2,
          )),
          prefixIcon: Icon(
            Icons.work,
            color: Color(0xFF5C7AEA),
          ),
          labelText: "Emp id",
          labelStyle: TextStyle(color: Color(0xFF5C7AEA)),
          helperText: "Id can't be empty",
          helperStyle: TextStyle(color: Color(0xFF5C7AEA)),
          hintText: 'Emp id',
          hintStyle: TextStyle(color: Colors.grey)));
}

Widget emailfield(TextEditingController controller) {
  return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF5C7AEA)),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Color(0xFF5C7AEA),
            width: 2,
          )),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Color(0xFF5C7AEA),
          ),
          labelText: "Email",
          labelStyle: TextStyle(color: Color(0xFF5C7AEA)),
          helperText: "email can't be empty",
          helperStyle: TextStyle(color: Color(0xFF5C7AEA)),
          hintText: 'Email',
          hintStyle: TextStyle(color: Colors.grey)));
}

// Widget phonefield(TextEditingController controller) {
//   return TextFormField(
//       controller: controller,
//       decoration: const InputDecoration(
//           border: OutlineInputBorder(
//             borderSide: BorderSide(color: Color(0xFF5C7AEA)),
//           ),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(
//             color: Color(0xFF5C7AEA),
//             width: 2,
//           )),
//           prefixIcon: Icon(
//             Icons.phone,
//             color: Color(0xFF5C7AEA),
//           ),
//           labelText: "Phone",
//           labelStyle: TextStyle(color: Color(0xFF5C7AEA)),
//           helperText: "number can't be empty",
//           helperStyle: TextStyle(color: Color(0xFF5C7AEA)),
//           hintText: 'Phone',
//           hintStyle: TextStyle(color: Colors.grey)));
// }

// Widget buttonfield() {
//   return
// }

// class UserProfile {
//   late final String name;
//   late final String emp_id;
//   late final String profile_photo_url;
//   final int phone;
//   late final String email;
//
//   UserProfile(
//       this.name, this.emp_id, this.profile_photo_url, this.phone, this.email);
// }

// Widget _buildImage() {
//   if (_image == null) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
//       child: Icon(
//         Icons.add,
//         color: Colors.grey,
//       ),
//     );
//   } else {
//     return Text(_image.path);
//   }
// }
