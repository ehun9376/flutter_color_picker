import 'package:color_picker/simple_widget/simple_text_field.dart';
import 'package:flutter/material.dart';

class BorderTextField extends StatelessWidget {
  const BorderTextField(
      {super.key,
      required this.textFieldOnEdited,
      required this.placeHolder,
      this.maxLines = 1,
      this.defaultText});

  final Function(String) textFieldOnEdited;

  final String? defaultText;
  final String placeHolder;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200, minHeight: 40),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SimpleTextField(
          defaultText: defaultText,
          borderColor: Colors.transparent,
          placeHolder: placeHolder,
          cornerRadius: 15,
          maxLines: maxLines,
          editedAction: (newValue) {
            textFieldOnEdited(newValue);
          },
        ),
      ),
    );
    ;
  }
}
