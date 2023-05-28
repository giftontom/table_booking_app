import 'package:cleanup_worker/appTheme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.controller,
      this.hintText,
      this.suffixIcon,
      this.minLines = 1,
      this.fontSize = 16,
      this.leftAlignSize = 0,
      this.rightAlignSize = 0,
      this.onChanged,
      this.onSubmit});

  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final double fontSize;
  final double leftAlignSize;
  final double rightAlignSize;
  final Widget suffixIcon;
  final Function(String) onChanged;
  final Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: leftAlignSize, right: rightAlignSize, top: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.getTheme().backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(38)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppTheme.getTheme().dividerColor,
              blurRadius: 8,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: TextField(
            maxLines: minLines,
            minLines: minLines,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              fontSize: fontSize,
            ),
            cursorColor: AppTheme.getTheme().primaryColor,
            decoration: new InputDecoration(
                errorText: null,
                border: InputBorder.none,
                labelText: hintText,
                hintText: hintText,
                hintStyle: TextStyle(color: AppTheme.getTheme().disabledColor),
                suffixIcon: suffixIcon),
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmit,
          ),
        ),
      ),
    );
  }
}
