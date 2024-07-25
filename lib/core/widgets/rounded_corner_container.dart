import 'package:flutter/cupertino.dart';
import 'package:visionapp/core/theme/app_palette.dart';

class RoundedCornerContainer extends StatelessWidget {
  final Widget child;
  final double height;

  const RoundedCornerContainer({super.key, required this.height, required
  this.child});

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: height,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(80), topRight: Radius.circular(80)),
          color: AppPalette.transparentBlue,

        ),
        child: child
    );
  }

}