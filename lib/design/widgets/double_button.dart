import 'package:flutter/material.dart';
import 'package:projects/design/colors.dart';
import 'package:projects/design/dimensions.dart';

class DoubleButton extends StatelessWidget {
  final String title;
  final Function() onTap;

  const DoubleButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 50),
            maximumSize: const Size(100, 50),
            backgroundColor: primaryColor,
            elevation: elevation0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius8)),
            padding: const EdgeInsets.only(left: padding16, right: padding16)),
        child: Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: surfaceColor,
                fontSize: fontSize16,
                fontWeight: FontWeight.w600)));
  }
}
