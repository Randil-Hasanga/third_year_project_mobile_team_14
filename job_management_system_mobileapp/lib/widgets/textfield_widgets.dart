import 'package:flutter/material.dart';

class TextFieldWidgets {
  TextFieldWidgets();

  Widget passwordTextField(bool showText, VoidCallback? onPressedIcon,
      Function(String?) onSaved, String labelText,
      {required bool validate}) {
    return TextFormField(
      obscureText: showText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: onPressedIcon,
          icon: const Icon(Icons.remove_red_eye),
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
      validator: validate ? (value) => validatePassword(value) : null,
    );
  }

  Widget passwordTextFieldStyle2(bool showText, VoidCallback? onPressedIcon,
      Function(String?) onSaved, String labelText,
      {required bool validate}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextFormField(
        obscureText: showText,
        decoration: InputDecoration(
          hintText: labelText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(
            Icons.lock,
            color: Color.fromARGB(255, 255, 115, 1),
          ),
          suffixIcon: IconButton(
            onPressed: onPressedIcon,
            icon: const Icon(Icons.remove_red_eye),
          ),
          border: InputBorder.none,
        ),
        onSaved: onSaved,
        validator: validate ? (value) => validatePassword(value) : null,
      ),
    );
  }

  bool hasUppercaseLetter(String value) {
    return value.contains(
      RegExp(r'[A-Z]'),
    );
  }

  bool hasNumber(String value) {
    return value.contains(
      RegExp(r'\d'),
    );
  }

  bool hasSpecialCharacter(String value) {
    return value.contains(
      RegExp(r'[^A-Za-z0-9]'),
    );
  }

  bool isValidEmail(String value) {
    return value.contains(
      RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter Email";
    }
    if (!isValidEmail(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter password";
    }
    if (value.length < 8) {
      return "Password should be at least 8 characters";
    }
    if (!hasUppercaseLetter(value)) {
      return "Please enter at least one uppercase letter";
    }
    if (!hasNumber(value)) {
      return "Password should have at least one number";
    }
    if (!hasSpecialCharacter(value)) {
      return "Please enter at least one special character";
    }
    return null;
  }

  Widget emailTextFieldStyleSignUp(Function(String?) onSaved, String labelText,
      {required bool validate}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: labelText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(
            Icons.mail,
            color: Color.fromARGB(255, 255, 115, 1),
          ),
          border: InputBorder.none,
        ),
        onSaved: onSaved,
        validator: validate ? (value) => validateEmail(value) : null,
      ),
    );
  }

  Widget usernameTextFieldStyleSignUp(
      Function(String?) onSaved, String labelText,
      {required bool validate}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: labelText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(
            Icons.person,
            color: Color.fromARGB(255, 255, 115, 1),
          ),
          border: InputBorder.none,
        ),
        onSaved: onSaved,
        validator: validate ? (value) => validateUsername(value) : null,
      ),
    );
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a username";
    } else {
      return null;
    }
  }
}
