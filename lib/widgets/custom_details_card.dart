import 'package:flutter/material.dart';
import 'package:vyavasaay/utils/constants.dart';

class CustomDetailsCard extends StatelessWidget {
  const CustomDetailsCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.trailing,
      required this.children});
  final String title;
  final Widget subtitle;
  final String trailing;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      child: ExpansionTile(
        backgroundColor: primaryColorLite,
        collapsedBackgroundColor: primaryColorLite,
        childrenPadding: EdgeInsets.symmetric(horizontal: defaultSize),
        title: Text(title, style: patientHeader),
        subtitle: subtitle,
        trailing: Text(
          trailing,
          style: patientHeaderSmall,
        ),
        children: children,
      ),
    );
  }
}
