import 'package:flutter/material.dart';
import 'package:vyavasaay/utils/constants.dart';

class DefaultContainer extends StatelessWidget {
  const DefaultContainer({
    super.key,
    required this.child,
    this.width,
    this.color,
    this.height,
    this.isPadding = false,
  });
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final bool? isPadding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          isPadding! ? EdgeInsets.all(defaultSize) : const EdgeInsets.all(0),
      height: height ?? getDeviceHeight(context: context),
      width: width ?? getDeviceWidth(context: context),
      decoration: BoxDecoration(
        color: color ?? primaryColorLite,
        borderRadius: BorderRadius.circular(
          defaultBorderRadius,
        ),
      ),
      child: child,
    );
  }
}
