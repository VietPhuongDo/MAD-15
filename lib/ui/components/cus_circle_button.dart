import 'package:flutter/material.dart';

class DualCircleButtons extends StatelessWidget {
  const DualCircleButtons({
    Key? key,
    required this.buttons,
  }) : super(key: key);

  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }
}


