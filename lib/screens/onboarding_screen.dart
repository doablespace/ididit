import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ididit/ui/color_theme.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FancyOnBoarding(
          pageList: [
            PageModel(
              color: ActivityColors.accentOrange,
              heroImagePath: 'assets/logo.png',
              icon: Icon(Icons.chevron_right_rounded),
              title: Text(
                'Track Your Habits',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'I Did It—a simple and beautiful app which you will want to use every day to track your habits and other activities.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            PageModel(
              color: ActivityColors.accentBlue,
              heroImagePath: 'assets/logo.png',
              icon: Icon(Icons.chevron_right_rounded),
              title: Text(
                'Just Swipe',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "It's easy. It's fun. It's like Tinder but more useful. Four directions, so you are not limited to just yes or no.",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            PageModel(
              color: ActivityColors.accentRed,
              heroImagePath: 'assets/logo.png',
              icon: Icon(Icons.chevron_right_rounded),
              title: Text(
                'Challenge Friends',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Are you too lazy but know what your friend should do? Create activity and send it to anyone. Then sit back and relax.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            PageModel(
              color: ActivityColors.accentPurple,
              heroImagePath: 'assets/logo.png',
              icon: Icon(Icons.chevron_right_rounded),
              title: Text(
                'Unleash Your Imagination',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'And leash your bad habits.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          onDoneButtonPressed: () async {
            await Hive.initFlutter('ididit');
            final box = await Hive.openBox('first_run');
            box.add(1);
            Navigator.pop(context);
          },
          doneButtonTextStyle: TextStyle(
            color: ThemeColors.lowerBackground,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
