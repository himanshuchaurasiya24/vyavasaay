import 'package:flutter/material.dart';
import 'package:vyavasaay/utils/constants.dart';

class CustomColumn extends StatelessWidget {
  const CustomColumn({
    super.key,
    required this.isVisible,
    required this.columnName,
  });

  final bool isVisible;
  final String columnName;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Expanded(
        flex: 1,
        child: Text(
          columnName,
          style: patientChildrenHeading,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
