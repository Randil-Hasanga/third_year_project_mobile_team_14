import 'package:flutter/material.dart';

class TextFieldWidgets {
  TextFieldWidgets();

  Widget passwordTextField(bool showTextOldPwd, VoidCallback? onPressedIcon,
      Function(String?) onSaved, String labelText) {
    return TextFormField(
      obscureText: showTextOldPwd,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(Icons.password_rounded),
        suffixIcon: IconButton(
          onPressed: onPressedIcon,
          icon: Icon(Icons.remove_red_eye),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 245, 245, 245),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 213, 210, 205),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
      ),
      onSaved: onSaved,
      validator: (_value) => _value!.length >= 8
          ? null
          : "Please enter password greater than 8 characters",
    );
  }
}
