import 'package:flutter/material.dart';
import 'package:vyavasaay/utils/constants.dart';

class UpdateScreenWidget extends StatelessWidget {
  const UpdateScreenWidget({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(defaultSize * 3),
      height: getDeviceHeight(context: context),
      width: getDeviceWidth(context: context),
      padding: EdgeInsets.all(defaultSize),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          defaultBorderRadius,
        ),
        color: primaryColorLite,
      ),
      child: child,
    );
  }
}
