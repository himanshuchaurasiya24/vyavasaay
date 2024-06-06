import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  const CustomRow({
    super.key,
    required this.isVisible,
    required this.title,
  });

  final bool isVisible;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Expanded(
        flex: 1,
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
