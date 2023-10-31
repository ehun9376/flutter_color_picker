import 'package:color_picker/simple_widget/simple_button.dart';
import 'package:flutter/material.dart';

class SimpleCheckBox extends StatefulWidget {
  const SimpleCheckBox(
      {super.key, required this.selected, required this.onChange});
  final bool selected;
  final Function(bool) onChange;

  @override
  State<SimpleCheckBox> createState() => _SimpleCheckBoxState();
}

class _SimpleCheckBoxState extends State<SimpleCheckBox> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleButton(
      imageSize: const Size(40, 40),
      buttonPadding: const EdgeInsets.all(0),
      iconSize: 15,
      iconColor: Colors.pink,
      buttonIcon: selected ? Icons.check : null,
      backgroundColor: Colors.white,
      borderColor: Colors.pink[50],
      borderWidth: 1.5,
      cornerRadius: 5,
      buttonAction: () {
        setState(() {
          selected = !selected;
        });
        widget.onChange(selected);
      },
    );
  }
}
