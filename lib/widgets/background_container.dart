import 'package:flutter/material.dart';
import 'package:vyavasaay/utils/constants.dart';

Widget background({
  double? width,
  double? rightMargin,
  required Widget child,
}) {
  return Container(
    height: double.infinity,
    width: width ?? 230,
    margin: EdgeInsets.only(
      left: defaultSize,
      top: defaultSize,
      bottom: defaultSize,
      right: rightMargin ?? 0,
    ),
    padding: const EdgeInsets.all(
      3,
    ),
    decoration: BoxDecoration(
      color: primaryColorDark,
    ),
    child: child,
  );
}
