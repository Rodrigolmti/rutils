import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_svg/svg.dart';

class CoreAssets extends StatelessWidget {
  const CoreAssets({
    required this.pathAssets,
    this.assetWidth = 24,
    this.assetHeight = 24,
    this.color,
    this.fit = BoxFit.scaleDown,
    this.tooltip,
    this.semanticsLabel,
    this.onPressed,
  });

  final double assetHeight;
  final double assetWidth;
  final BoxFit fit;
  final Color? color;
  final String? tooltip;
  final VoidCallback? onPressed;
  final String pathAssets;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip ?? '',
        child: Semantics(
          button: true,
          label: semanticsLabel,
          child: GestureDetector(
            onTap: onPressed,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              pathAssets,
              width: assetWidth,
              height: assetHeight,
              fit: fit,
              excludeFromSemantics: true,
              color: color,
            ),
          ),
        ),
      );
}
