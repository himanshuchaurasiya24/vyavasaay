import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/default_container.dart';

class ContainerButton extends StatefulWidget {
  const ContainerButton({
    super.key,
    required this.iconData,
    required this.btnName,
    this.backgroundColor,
    this.isLoading = false,
    this.loadingWidget = const SizedBox(),
  });
  final bool? isLoading;
  final Widget? loadingWidget;
  final IconData iconData;
  final String btnName;
  final Color? backgroundColor;
  @override
  State<ContainerButton> createState() => _ContainerButtonState();
}

class _ContainerButtonState extends State<ContainerButton> {
  Color containerColor = primaryColorDark;
  @override
  void initState() {
    super.initState();
    containerColor = widget.backgroundColor ?? primaryColorDark;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          containerColor = btnColor;
        });
      },
      onExit: (event) {
        setState(() {
          containerColor = widget.backgroundColor ?? primaryColorDark;
        });
      },
      child: DefaultContainer(
        color: containerColor,
        height: getDeviceHeight(context: context) * 0.125,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.isLoading!
                  ? widget.loadingWidget!
                  : Icon(
                      widget.iconData,
                      size: 30,
                    ),
              Gap(defaultSize),
              Text(
                widget.btnName,
                style: patientHeader,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
