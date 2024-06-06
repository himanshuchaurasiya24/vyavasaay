import 'package:flutter/material.dart';
import 'package:vyavasaay/widgets/introscreen_widget.dart';

class IntroScreen3 extends StatelessWidget {
  const IntroScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return const IntroScreenWidget(
      imageUrl: 'assets/intro3.png',
      description: 'Generate\nMonthly/ Yearly\nInvoice.',
    );
  }
}
