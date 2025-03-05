import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String asset;
  final Color? color;
  final double? size;
  final bool invert;
  const SvgIcon(
    this.asset, {
    super.key,
    this.color,
    this.size = 24,
    this.invert = false,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture(
      SvgAssetLoader(asset),
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.onSurface,
        BlendMode.srcIn,
      ),
    );
  }
}
