import 'package:flutter/material.dart';
import 'package:projects/design/colors.dart';
import 'package:projects/design/dimensions.dart';

class AddButton extends StatelessWidget {
  final String title;
  final Function() onTap;

  const AddButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(250, 60),
            maximumSize: const Size.fromHeight(60),
            backgroundColor: secondaryVariantColor,
            elevation: elevation0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius8 * 2)),
            padding: const EdgeInsets.only(left: padding16, right: padding16)),
        child: Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: surfaceColor,
                fontSize: fontSize16 + 6,
                fontWeight: FontWeight.w600)));
  }
}
