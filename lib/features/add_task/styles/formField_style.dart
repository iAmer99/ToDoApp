import 'package:flutter/material.dart';

InputDecoration myDecoration({required String label, required String hint, required Icon myIcon}){
  return InputDecoration(
    labelText: label,
    hintStyle: TextStyle(
      color: Colors.black.withOpacity(0.4),
    ),
    hintText: hint,
    border: InputBorder.none,
    prefixIcon: myIcon,
  );
}