import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/bloc/bloc_provider.dart';
import 'package:ididit/data/database.dart';
import 'package:ididit/screens/swiping_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Db>(create: (_) => Db()),
        BlocProvider<ActivitiesBloc>(create: (context) {
          return ActivitiesBloc(Provider.of<Db>(context, listen: false));
        }),
      ],
      child: MaterialApp(
        title: 'I Did It',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            // Apply Raleway font throughout app.
            textTheme: GoogleFonts.ralewayTextTheme(
              Theme.of(context).textTheme,
            )),
        home: SwipingScreen(),
      ),
    );
  }
}
