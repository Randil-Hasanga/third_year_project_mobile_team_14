import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/colors/colors.dart';

class ButtonWidgets {
  ButtonWidgets();

  Widget simpleElevatedButtonWidget({
    VoidCallback? onPressed,
    ButtonStyle? style,
    String? buttonText,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style ??
          ElevatedButton.styleFrom(
            backgroundColor: buttonDefaultColorOrange,
          ),
      child: Text(
        "$buttonText",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
