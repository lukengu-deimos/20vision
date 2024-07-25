import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visionapp/core/theme/app_palette.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const TopBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size:
        20,),
        onPressed: () {
          SystemSound.play(SystemSoundType.click);
          Navigator.pop(context);
        },
      ),
      title:Text(title.toUpperCase(), style: const TextStyle(
          letterSpacing: 1.5 ,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22)),
      backgroundColor: AppPalette.transparent,
    );
  }
}