import "package:flutter/material.dart";
class EmptyAttachmentButton extends StatelessWidget {
  const EmptyAttachmentButton({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.3,
        margin: const EdgeInsets.only(bottom: 20) ,
    child: Column(children: [
      Container(
      width: 71,
      height: 71,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent
      ),
    )]));
  }
}