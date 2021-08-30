import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard({required this.child, Key? key, this.radius = 4})
      : super(key: key);
  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: child,
      );
}

class RoundedBorder extends StatelessWidget {
  const RoundedBorder({
    this.child,
    Key? key,
    this.color,
    this.width = 0,
    this.radius = 0,
    this.ignorePointer = true,
  }) : super(key: key);
  final Color? color;
  final double width;
  final double radius;
  final bool ignorePointer;
  final Widget? child;

  @override
  Widget build(BuildContext context) => IgnorePointer(
        ignoring: ignorePointer,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: color ?? Colors.white,
              width: width,
            ),
          ),
          child: child,
        ),
      );
}
