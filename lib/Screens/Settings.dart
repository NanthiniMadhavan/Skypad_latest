import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_pad/models/Thememodel.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return AlertDialog(
      title: Text(
        'you are not allowed to access this page',
        style: TextStyle(color: Colors.black),
      ),
    );

    // body: Column(
    //   children: [
    //     ToggleButtons(
    //       isSelected: [
    //         themeProvider.currentTheme == AppTheme.Light,
    //         themeProvider.currentTheme == AppTheme.Dark,
    //         themeProvider.currentTheme == AppTheme.Custom,
    //       ],
    //       onPressed: (int index) {
    //         switch (index) {
    //           case 0:
    //             themeProvider.setTheme(AppTheme.Light);
    //             break;
    //           case 1:
    //             themeProvider.setTheme(AppTheme.Dark);
    //             break;
    //           case 2:
    //             themeProvider.setTheme(AppTheme.Custom);
    //             break;
    //         }
    //       },
    //       children: [
    //         Icon(Icons.wb_sunny), // Light Theme Icon
    //         Icon(Icons.nightlight_round), // Dark Theme Icon
    //         Icon(Icons.color_lens), // Custom Theme Icon
    //       ],
    //     ),
    //   ],
    // ),
  }
}
