import 'package:flutter/material.dart';
import 'package:projects/design/colors.dart';
import 'package:projects/design/dimensions.dart';
import 'package:projects/design/widgets/add_button.dart';

class ErrorDialog extends StatelessWidget {
  final String description;

  const ErrorDialog({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius8)),
        child: Padding(
            padding: const EdgeInsets.all(padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Ошибка",
                    style: TextStyle(
                        color: secondColor,
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize16)),
                const SizedBox(height: height8),
                Text(description,
                    style: const TextStyle(
                        color: secondColor,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize16)),
                const SizedBox(height: height8 * 2 + 4),
                Center(
                  child: AddButton(
                      title: "OK",
                      onTap: () {
                        Navigator.pop(context);
                      }),
                )
              ],
            )));
  }
}
