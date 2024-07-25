import 'package:flutter/material.dart';
import 'package:visionapp/core/theme/app_palette.dart';

class Loader extends StatelessWidget {
  final String message;
  final Color color;

  const Loader({super.key, this.message='', this.color = AppPalette.primaryBlue});
  @override
  Widget build(BuildContext context) {
    return  Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: color,),
        if(message.isNotEmpty) const SizedBox(height: 10),
        if(message.isNotEmpty) Text(message , style: const TextStyle(color:
        AppPalette.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    ));
  }
}