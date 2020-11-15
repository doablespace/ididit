import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/bloc/bloc_provider.dart';
import 'package:ididit/data/database.dart';
import 'package:ididit/platform/deep_link_listener.dart';
import 'package:ididit/screens/swiping_screen.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create theme with app colors.
    final baseTheme = ThemeData.from(
      colorScheme: ColorScheme.light(
        primary: ThemeColors.lowerBackground,
        onPrimary: ThemeColors.upperBackground,
      ),
      // Apply Raleway font throughout app.
      textTheme: GoogleFonts.ralewayTextTheme(
        Theme.of(context).textTheme,
      ),
    );

    // Invert `AppBar` theme (to have light background).
    final theme = baseTheme.copyWith(
      appBarTheme: baseTheme.appBarTheme.copyWith(
        color: baseTheme.colorScheme.onPrimary,
        textTheme: baseTheme.textTheme.apply(
          bodyColor: baseTheme.colorScheme.primary,
        ),
        actionsIconTheme: baseTheme.primaryIconTheme.copyWith(
          color: baseTheme.colorScheme.primary,
        ),
        iconTheme: baseTheme.primaryIconTheme.copyWith(
          color: baseTheme.colorScheme.primary,
        ),
      ),
    );

    return MultiProvider(
      providers: [
        Provider<Db>(create: (_) => Db()),
        BlocProvider<ActivitiesBloc>(create: (context) {
          return ActivitiesBloc(Provider.of<Db>(context, listen: false));
        }),
      ],
      child: MaterialApp(
        title: 'I Did It',
        theme: theme,
        home: Stack(
          children: [
            DeepLinkListener(),
            SwipingScreen(),
          ],
        ),
      ),
    );
  }
}
