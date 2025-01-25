import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_time/common/common.dart';

class CustomElevatedButton extends StatefulWidget {
  final String message;
  final FutureOr<void> Function() function;
  final Color? color;
  const CustomElevatedButton({
    Key? key,
    required this.message,
    required this.function,
    this.color = Colors.white,
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
      style: ButtonStyle(
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
          : FittedBox(
        child: Text(
          widget.message,
          style: Common().semiboldwhite,
        ),
      ),
    );
  }
}
