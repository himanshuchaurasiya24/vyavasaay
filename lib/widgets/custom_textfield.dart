import 'package:flutter/material.dart';
import 'package:vyavasaay/utils/constants.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.isObscure = false,
    required this.hintText,
    this.keyboardType,
    this.passwordController,
    this.isConfirm,
    this.readOnly,
    this.maxLines,
    this.onChanged,
    this.valueLimit,
    this.suffixIconRequired = false,
    this.fillColor,
    this.hoverColor,
  });

  final TextEditingController controller;
  final bool? isObscure;
  final String hintText;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextEditingController? passwordController;
  final bool? isConfirm;
  final bool? suffixIconRequired;
  final bool? readOnly;
  final int? maxLines;
  final int? valueLimit;
  final Color? fillColor;
  final Color? hoverColor;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = false;
  @override
  void initState() {
    super.initState();
    isObscure = widget.isObscure! ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorRadius: Radius.circular(defaultBorderRadius),
      cursorWidth: 3.0,
      onChanged: widget.onChanged,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines ?? 1,
      obscureText: isObscure,
      readOnly: widget.readOnly ?? false,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      validator: (value) {
        if (widget.isConfirm == true && widget.passwordController != null) {
          if (value != widget.passwordController!.text) {
            return 'Password does\'nt match';
          }
        }
        if (value != null && value.trim().isEmpty) {
          return 'Please enter ${widget.hintText}';
        }
        if (widget.valueLimit != null &&
            widget.keyboardType == TextInputType.number &&
            value != null) {
          int pValue = int.tryParse(value)!;
          if (pValue > widget.valueLimit!) {
            return 'Range is only upto ${widget.valueLimit}';
          }
        }
        if (value != null && widget.keyboardType == TextInputType.number) {
          final intvalue = int.tryParse(value);
          if (intvalue == null) {
            return 'Invalid ${widget.hintText}';
          }
        }

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        suffixIcon: widget.isObscure!
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: const Icon(
                  Icons.visibility,
                ),
              )
            : null,
        hoverColor: widget.hoverColor ?? primaryColorDark,
        fillColor: widget.fillColor ?? primaryColorDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            defaultBorderRadius,
          ),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
