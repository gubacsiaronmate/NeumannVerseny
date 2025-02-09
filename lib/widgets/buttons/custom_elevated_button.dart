import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/common.dart';

class CustomElevatedButton extends StatefulWidget {
  final String message;
  final IconData? icon;
  final FutureOr<void> Function() function;
  final Color? color;
  final ButtonStyle? style;

  const CustomElevatedButton({
    Key? key,
    required this.message,
    this.icon,
    required this.function,
    this.color,
    this.style,
  }) : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = widget.color ?? Theme.of(context).colorScheme.primary;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return ElevatedButton(
      onPressed: () async {
        setState(() {
          loading = true;
        });
        if (widget.function != null) {
          await widget.function();
        }
        setState(() {
          loading = false;
        });
      },
      style: widget.style ?? ButtonStyle(
        side: MaterialStatePropertyAll(BorderSide(color: Theme.of(context).colorScheme.onBackground)),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        fixedSize: const MaterialStatePropertyAll(Size.fromWidth(370)),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 20),
        ),
        backgroundColor: MaterialStatePropertyAll(backgroundColor),
      ),
      child: loading
          ? const CupertinoActivityIndicator()
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, color: textColor),
            const SizedBox(width: 5),
          ],
          FittedBox(
            child: Text(
              widget.message,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}