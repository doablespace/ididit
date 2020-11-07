import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ididit/screens/swiping_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I Did It',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // Apply Raleway font throughout app.
          textTheme: GoogleFonts.ralewayTextTheme(
            Theme.of(context).textTheme,
          )),
      home: SwipingScreen(),
    );
  }
}
