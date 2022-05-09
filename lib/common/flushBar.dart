import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar showCustomFlushBar(BuildContext context, String text, Icon icon) {
  return Flushbar(
    icon: icon,
    shouldIconPulse: false,
    message: text,
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.black,
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.circular(8),
  )..show(context);
}
