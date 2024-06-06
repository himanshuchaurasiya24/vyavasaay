import 'package:flutter/material.dart';
import 'package:vyavasaay/widgets/introscreen_widget.dart';

class IntroScreen2 extends StatelessWidget {
  const IntroScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return const IntroScreenWidget(
        imageUrl: 'assets/intro2.png',
        description: 'Keep Patient\nHistory\nRecorded.');
  }
}
