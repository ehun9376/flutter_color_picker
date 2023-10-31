import 'dart:io';

import 'package:flutter/material.dart';

class SimpleImage extends StatelessWidget {
  final Color? backgroudColor;
  final String? imageName;
  final String? imageURL;

  final File? imageFile;

  final Size? size;
  final double? cornerRadius;

  final IconData? icon;
  final Color? color;
  final double? iconSize;

  final Color? borderColor;

  final BoxFit? fit;

  const SimpleImage(
      {super.key,
      this.imageName,
      this.imageURL,
      this.size,
      this.cornerRadius,
      this.icon,
      this.color,
      this.iconSize,
      this.backgroudColor,
      this.imageFile,
      this.fit,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroudColor,
          borderRadius: BorderRadius.circular(cornerRadius ?? 0),
          border:
              Border.all(width: 0.5, color: borderColor ?? Colors.transparent)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius ?? 0),
        child: imageFile != null
            ? Image.file(
                imageFile!,
                width: size?.width,
                height: size?.height,
                fit: fit ?? BoxFit.fill,
              )
            : icon != null
                ? Icon(
                    icon,
                    size: iconSize,
                    color: color,
                  )
                : (imageURL == null
                    ? Image.asset(
                        imageName != null
                            ? 'images/$imageName'
                            : "images/placeholder-image.png",
                        height: size?.height,
                        width: size?.width,
                        fit: fit ?? BoxFit.fill,
                        color: color,
                      )
                    : getImageFromNet(imageURL ?? "")),
      ),
    );
  }

  Image getImageFromNet(String imageURL) {
    return Image.network(imageURL,
        height: size?.height,
        width: size?.width,
        fit: fit ?? BoxFit.fill,
        color: color, errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
      debugPrint("Image loading failed: $exception");
      return Image.asset(
        "images/placeholder-image.png",
        height: size?.height,
        width: size?.width,
        fit: fit ?? BoxFit.fill,
      );
    }, loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Image.asset(
        "images/placeholder-image.png",
        height: size?.height,
        width: size?.width,
        fit: fit ?? BoxFit.fill,
      );
    });
  }
}
