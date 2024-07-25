import 'package:flutter/material.dart';

class SlideUpPageTransformer extends PageTransformer {
  @override
  Widget transform(Widget child, TransformInfo info) {
    final double position = info.page - info.index;
    final double opacity = 1 - position.abs().clamp(0.0, 1.0);
    final double translateY = position * 100.0;

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, translateY),
        child: child,
      ),
    );
  }
}

abstract class PageTransformer {
  Widget transform(Widget child, TransformInfo info);

  Widget builder(BuildContext context, Widget child, TransformInfo info) {
    return transform(child, info);
  }
}

class TransformInfo {
  final double page;
  final int index;

  TransformInfo(this.page, this.index);
}
