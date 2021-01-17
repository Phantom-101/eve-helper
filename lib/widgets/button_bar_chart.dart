import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ButtonBarChart extends StatelessWidget {
  final Widget child;
  final List<Widget> buttons;

  ButtonBarChart({@required this.child, @required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        child,
        Row(
          children: buttons,
        ),
      ],
    );
  }
}