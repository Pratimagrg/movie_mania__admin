import 'package:flutter/material.dart';

mySnackbar(message, context) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
