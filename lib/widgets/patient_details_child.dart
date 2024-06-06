import 'package:flutter/material.dart';
import 'package:vyavasaay/utils/constants.dart';

class PatientDetailsChild extends StatelessWidget {
  const PatientDetailsChild({
    super.key,
    required this.heading,
    this.value,
    this.isWidgetInValue = false,
    this.valueWidget,
  });
  final String heading;
  final String? value;
  final bool? isWidgetInValue;
  final Widget? valueWidget;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          heading,
          textAlign: TextAlign.start,
          style: patientChildrenHeading,
        ),
        isWidgetInValue!
            ? valueWidget!
            : Text(
                textAlign: TextAlign.end,
                value ?? '',
                style: patientHeaderSmall,
              ),
      ],
    );
  }
}
