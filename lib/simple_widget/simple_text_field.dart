import 'package:flutter/material.dart';

class SimpleTextField extends StatelessWidget {
  final TextInputType? keyboardType;

  final String? defaultText;

  final String? placeHolder;

  final Color? backgroundColor;

  final Function(String newValue)? editedAction;
  final Function(String newValue)? subAction;

  final double? cornerRadius;

  final Color? borderColor;

  final double? borderWidth;

  final int? maxLines;

  final bool? readOnly;

  const SimpleTextField(
      {super.key,
      this.defaultText,
      this.backgroundColor,
      this.cornerRadius,
      this.borderColor,
      this.borderWidth,
      this.placeHolder,
      this.editedAction,
      this.subAction,
      this.keyboardType,
      this.maxLines,
      this.readOnly});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: defaultText);
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(cornerRadius ?? 0),
      ),
      child: TextField(
        readOnly: readOnly ?? false,
        textAlignVertical: TextAlignVertical.center,
        maxLines: maxLines,
        textInputAction: (maxLines ?? 1) > 1
            ? TextInputAction.newline
            : TextInputAction.done,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 5,
            bottom: 5,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(cornerRadius ?? 0),
            borderSide: BorderSide(
              color: borderColor ?? Colors.blue,
              width: borderWidth ?? 0,
            ),
          ),
          hintText: placeHolder,
        ),
        onChanged: editedAction,
        onSubmitted: subAction,
      ),
    );
  }
}
