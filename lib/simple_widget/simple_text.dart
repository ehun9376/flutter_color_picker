import 'package:flutter/material.dart';

class SimpleText extends StatelessWidget {
  final String? text;

  final int? lines;

  final double? fontSize;

  final FontWeight? fontWeight;

  final Color? textColor;

  final FontStyle? style;

  final TextAlign? align;

  final bool? autoFitWidth;

  const SimpleText(
      {Key? key,
      this.text,
      this.fontSize,
      this.fontWeight,
      this.textColor,
      this.lines,
      this.style,
      this.align,
      this.autoFitWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (autoFitWidth ?? false) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          (text ?? ""),
          softWrap: true,
          maxLines: lines ?? 999,
          overflow: TextOverflow.ellipsis,
          textAlign: align,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
              fontStyle: style),
        ),
      );
    } else {
      return Text(
        (text ?? ""),
        softWrap: true,
        maxLines: lines ?? 999,
        overflow: TextOverflow.ellipsis,
        textAlign: align,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
            fontStyle: style),
      );
    }
  }
}
