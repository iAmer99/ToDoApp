import 'package:flutter/material.dart';

final RegExp _emailRegExp = RegExp(
  r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
);

String? isValidEmail(BuildContext context, String? email) {
  if (email!.trim().isEmpty) return "Email is empty";
  return _emailRegExp.hasMatch(email.trim()) ? null : "Invalid email";
}

String? isValidName(BuildContext context, String? value) {
  return value!.isNotEmpty ? null : "Name is empty";
}

String? isValidCode(BuildContext context, String? value) {
  return value!.isNotEmpty ? null : "Code is empty";
}

String? isValidPhone(BuildContext context, String? phone) {
  //Todo change the length validation later
  return phone!.isNotEmpty ? null : "Mobile is empty";
}

String? confirmPassword(
    BuildContext context, String password, String? confirmedPassword) {
  if (confirmedPassword!.isEmpty) return "Password is empty";
  return password == confirmedPassword ? null : "Passwords must match";
}

String? isValidPassword(BuildContext context, String? password) {
  if (password!.isEmpty) return "Password is empty";
  return password.length >= 6 ? null : "Password is to short";
}
