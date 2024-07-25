import 'package:flutter/cupertino.dart';
import 'package:visionapp/core/theme/app_palette.dart';

class AssetIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color color;

  const AssetIcon({super.key, required this.assetPath, this.size = 24, this
      .color = AppPalette.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(5), child: Image.asset(
      assetPath,
      width: size,
      height: size,
      color: color,
    ),);
  }

}