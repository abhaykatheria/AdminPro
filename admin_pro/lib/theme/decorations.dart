import 'package:flutter/material.dart';

InputDecoration getTextDecoration(String label) {
  return InputDecoration(
    labelStyle: TextStyle(color: Colors.black45),
    border: OutlineInputBorder(),
    labelText: label,
  );
}
