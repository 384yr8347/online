import 'package:flutter/material.dart';

ThemeData Lightmode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Color.fromARGB(255, 82, 147, 122),
    secondary:Color.fromARGB(255, 255, 255, 255),
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade800,
    onPrimary:Color.fromARGB(255, 234, 252, 245), 
    onSecondary: Colors.black,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.w800), 
    bodyMedium: TextStyle(color: Colors.black87,fontSize: 17.0, fontWeight: FontWeight.bold,),
    headlineSmall: TextStyle(color: Colors.black, fontSize: 16.0,),
  ),
  
);

ThemeData Darkmode = ThemeData(
  colorScheme: ColorScheme.dark(
    background: Color.fromARGB(255, 33, 33, 33),
    primary: Color.fromARGB(255, 82, 147, 122),
    secondary: Color.fromARGB(255, 33, 33, 33),
    tertiary: Colors.greenAccent,
    inversePrimary: Colors.grey.shade300,
    onPrimary:Color.fromARGB(255, 31, 44, 39), 
    onSecondary: Colors.white,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w800), 
    bodyMedium: TextStyle(color: Colors.white70,fontSize: 17.0, fontWeight: FontWeight.bold,),
    headlineSmall: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 16.0,),
  ),
);












// TextField(
//   style: TextStyle(color: Colors.black),
//   decoration: InputDecoration(
//     border: OutlineInputBorder(),
//     enabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Color.fromARGB(255, 173, 216, 230)),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Color.fromARGB(255, 173, 216, 230)),
//     ),
//   ),
// );

// TextField(
//   style: TextStyle(color: Colors.white),
//   decoration: InputDecoration(
//     border: OutlineInputBorder(),
//     enabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 139)),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 139)),
//     ),
//   ),
// );
