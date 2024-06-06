import 'package:flutter/material.dart';
import 'package:vyavasaay/widgets/introscreen_widget.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return const IntroScreenWidget(
        imageUrl: 'assets/intro1.png',
        description: 'Generate your\nMonthly/ Yearly\nRevenue.');
  }
}
