import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/default_container.dart';

class IntroScreenWidget extends StatelessWidget {
  const IntroScreenWidget({
    super.key,
    required this.imageUrl,
    required this.description,
  });
  final String imageUrl;
  final String description;

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.all(defaultSize),
            child: Image.asset(imageUrl),
          ),
          AnimatedTextKit(
            repeatForever: false,
            totalRepeatCount: 1,
            animatedTexts: [
              TypewriterAnimatedText(
                speed: const Duration(milliseconds: 40),
                textAlign: TextAlign.center,
                description,
                textStyle: TextStyle(
                  fontSize: titleLargeTextSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
