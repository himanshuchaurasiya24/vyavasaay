import 'package:flutter/material.dart';
import 'package:vyavasaay/screens/introduction_screens/intro_1.dart';
import 'package:vyavasaay/screens/introduction_screens/intro_2.dart';
import 'package:vyavasaay/screens/introduction_screens/intro_3.dart';
import 'package:vyavasaay/screens/introduction_screens/intro_4.dart';
import 'package:vyavasaay/screens/login_signup_screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyavasaay/widgets/custom_page_route.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  List<Widget> introScreens = <Widget>[
    const IntroScreen1(),
    const IntroScreen2(),
    const IntroScreen3(),
    const IntroScreen4(),
  ];
  int currentIndex = 0;
  void intro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isIntrodu', true);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          setState(() {
            if (currentIndex < 3) {
              currentIndex++;
            } else {
              if (currentIndex == 3) {
                intro();
                Navigator.pushReplacement(
                  context,
                  // MaterialPageRoute(
                  //   builder: (context) {
                  //     return const LoginScreen();
                  //   },
                  // ),
                  MyCustomPageRoute(
                    route: const LoginScreen(),
                  ),
                );
              }
            }
          });
        },
        label: Text(currentIndex == 3 ? 'Get Started' : ''),
        icon: const Icon(
          Icons.arrow_right_alt_outlined,
        ),
      ),
      body: introScreens[currentIndex],
    );
  }
}
