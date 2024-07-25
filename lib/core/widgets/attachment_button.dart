import "package:flutter/material.dart";
import "package:visionapp/core/theme/app_palette.dart";





class AttachmentButton extends StatelessWidget {
  final String name;
  final Icon icon;
  final Function()? onTap;

  const AttachmentButton({
    super.key,
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:  SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(children: [
          Container(
            width: 71,
            height: 71,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.lightGray
            ),
            child: icon,
          ),
          const SizedBox(height: 10,),
          Text(name, style: const TextStyle(color: AppPalette.white, fontSize:
          11, fontWeight: FontWeight.bold))
        ],),
      ),
    );

  }
}