import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:vyavasaay/utils/constants.dart';

class AboutThisApp extends StatelessWidget {
  const AboutThisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1280,
      width: 640,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: primaryColorLite,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/vyavasaay.png',
              height: 250,
              width: 250,
            ),
            AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText(
                  speed: const Duration(milliseconds: 71),
                  'Vyavasaay v1.0',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 100,
                    color: btnColor,
                  ),
                ),
              ],
              isRepeatingAnimation: false,
            ),
            Text(
              'Designed & Developed by Himanshu Chaurasiya',
              style: patientHeader,
            )
          ],
        ),
      ),
    );
  }
}
