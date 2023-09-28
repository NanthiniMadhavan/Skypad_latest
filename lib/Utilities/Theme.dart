import 'package:flutter/material.dart';

// final dark_blue = Color(0xFF001E36);

ThemeData darkTheme = ThemeData.dark().copyWith(
  // scaffoldBackgroundColor: dark_blue,
  primaryColor: Colors.white,
  hintColor: Color(0xFF31A8FF),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontFamily: "InknutAntiqua",
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontFamily: "Kablammo",
      fontSize: 15.0,
      color: Colors.black,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
    centerTitle: true,
    elevation: 0,
  ),
  iconTheme: IconThemeData(
    color: Color(0xFF31A8FF),
  ),
);

ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: Color(0xfff5f5f5),
  hintColor: Color(0xff40bf7a),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontFamily: "Kablammo",
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontFamily: "Kablammo",
      fontSize: 15.0,
      color: Colors.black,
    ),
  ),
  appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF001E36),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20.0,
      )),
  iconTheme: IconThemeData(
    color: Color(0xFF76D7EA),
  ),
);

ThemeData customDefaultTheme = ThemeData(
  fontFamily: 'Lato',
  scaffoldBackgroundColor: Color(0xFF27374D),
  primaryColor: Colors.white,
  hintColor: Color(0xFFBDD1F8),
  appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.white10,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
  textTheme: TextTheme(
    titleLarge: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        // color: Color(0xFFBDD1F8),
        color: Colors.white),
    titleMedium: TextStyle(
      fontSize: 15.0,
      color: Colors.black, //Content
    ),
    displayLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        // color: Color(0xFFBDD1F8),
        color: Colors.white
        //larger display
        ),
    displayMedium: TextStyle(
        fontSize: 10.0,
        // color: Color(0xFFBDD1F8), //inside the text field
        color: Colors.white),
    displaySmall: TextStyle(fontSize: 18.0, color: Colors.white),
    titleSmall: TextStyle(
      fontSize: 12.0,
      color: Color(0xFF8A99B5), // small text
    ),
  ),

  // iconTheme: IconThemeData(
  //   color: Colors.white, // Customize this color for the custom theme
  //   // size: 70.0,
  // ),
  inputDecorationTheme: InputDecorationTheme(
    // enabledBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.black, width: 2),
    // ),
    // focusedBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.black, width: 2),
    // ),
    // border: OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.black, width: 2),
    // ),
    hintStyle: TextStyle(color: Colors.white),
  ),
  // Add IconButtonTheme
  // iconButtonTheme: IconButtonThemeData(
  //   color: Color(0xFF31A8FF), // Customize this color for icon buttons
  //   // size: 70.0, // You can set the size if needed
  // ),

  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF0F5EF7),
        // side: BorderSide(color: Color(0xFF0F5EF7)),
        fixedSize: Size(200, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        textStyle: TextStyle(
          fontSize: 20.0,
        )),
  ),
);
