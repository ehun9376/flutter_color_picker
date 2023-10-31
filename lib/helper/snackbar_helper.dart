import 'package:color_picker/simple_widget/simple_text.dart';
import 'package:flutter/material.dart';

void showAppSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
        child: SimpleText(
      text: message,
      fontSize: 16,
    )),
  ));
}
