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
    this.color = Colors.white,
    this.style,
  }) : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
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
        side: const MaterialStatePropertyAll(BorderSide(color: Colors.grey)),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        fixedSize: const MaterialStatePropertyAll(Size.fromWidth(370)),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 20),
        ),
        backgroundColor: MaterialStatePropertyAll(widget.color),
      ),
      child: loading
          ? const CupertinoActivityIndicator()
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, color: Colors.white),
            const SizedBox(width: 5),
          ],
          FittedBox(
            child: Text(
              widget.message,
              style: Common().semiboldwhite,
            ),
          ),
        ],
      ),
    );
  }
}