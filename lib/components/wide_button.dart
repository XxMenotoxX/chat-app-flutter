import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final Function() onPressed;

  final String buttonName;

  final Color buttonColor;

  const WideButton(
      {Key? key,
      required this.buttonColor,
      required this.onPressed,
      required this.buttonName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
