import 'package:flutter/material.dart';

class PositionedAll extends StatelessWidget {
  const PositionedAll({
    required this.child,
    Key? key,
    this.all = 0,
  }) : super(key: key);
  final Widget child;
  final double all;

  @override
  Widget build(BuildContext context) => Positioned(
        left: all,
        top: all,
        right: all,
        bottom: all,
        child: child,
      );
}
