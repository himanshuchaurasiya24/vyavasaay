import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyavasaay/database/database_helper.dart';
import 'package:vyavasaay/screens/introduction_screens/introduction_screen.dart';
import 'package:vyavasaay/screens/login_signup_screens/login_screen.dart';
import 'package:vyavasaay/screens/main_screen/home_screen.dart';

final idProvider = StateProvider<int>((ref) => 0);
final nameProvider = StateProvider<String>((ref) => 'null');

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final DatabaseHelper database = DatabaseHelper();
  String centerName = '';
  String loggedInName = 'null';

  @override
  void initState() {
    isIntro();
    database.initDB();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void isIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isIntro = prefs.getBool('isIntrodu') ?? false;
    bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    int? loggedInId = prefs.getInt('loggedInId') ?? 0;
    String? logInType = prefs.getString('logInType') ?? 'Technician';
    String centerName = prefs.getString('centerName') ?? '';
    loggedInName = loggedInId == 0
        ? 'null'
        : await database.getAccountName(id: loggedInId);
    final adminActLength = await database.getAdminAccountLength();
    ref.read(idProvider.notifier).state = loggedInId;
    ref.read(nameProvider.notifier).state = loggedInName;
    if (adminActLength == 0) {
      await prefs.clear().then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const IntroductionScreen();
            },
          ),
        );
      });

      return;
    }
    if (isIntro) {
      if (isLoggedIn && loggedInName != 'null') {
        Timer(
          const Duration(seconds: 1),
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomeScreen(
                    centerName: centerName,
                    name: loggedInName,
                    logInType: logInType,
                  );
                },
              ),
            );
          },
        );
      } else {
        Timer(
          const Duration(seconds: 1),
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const LoginScreen();
                },
              ),
            );
          },
        );
      }
    } else {
      Timer(
        const Duration(seconds: 1),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const IntroductionScreen();
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 300,
                backgroundColor: Colors.transparent,
                child: Image.asset('assets/vyavasaay.png'),
              ),
              AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText(
                    speed: const Duration(milliseconds: 80),
                    'Vyavasaay',
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 100,
                    ),
                  ),
                ],
                isRepeatingAnimation: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
