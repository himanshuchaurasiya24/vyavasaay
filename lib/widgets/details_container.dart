import 'package:flutter/material.dart';
import 'package:vyavasaay/utils/constants.dart';

class DetailsContainer extends StatelessWidget {
  const DetailsContainer({
    super.key,
    this.height,
    this.width,
    required this.borderText,
    required this.childWidget,
  });
  final int? height;
  final int? width;
  final String borderText;
  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: getDeviceHeight(context: context) * 0.060,
          width: getDeviceWidth(context: context) * 0.17,
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(defaultBorderRadius),
              topRight: Radius.circular(defaultBorderRadius),
            ),
          ),
          child: Center(
            child: Text(
              borderText,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: patientChildrenHeading,
            ),
          ),
        ),
        Container(
          height: getDeviceHeight(context: context) * 0.20,
          width: getDeviceWidth(context: context) * 0.17,
          decoration: BoxDecoration(
            color: primaryColorLite,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(defaultBorderRadius),
              bottomRight: Radius.circular(defaultBorderRadius),
            ),
          ),
          child: Center(
            child: childWidget,
          ),
        ),
      ],
    );
  }
}
