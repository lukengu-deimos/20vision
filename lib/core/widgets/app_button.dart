import 'package:flutter/material.dart';


class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color color;
  final bool ?bold;
  final String ?title;
  final RichText ?richText;
  const AppButton({super.key, required this.onPressed, this.title,
    required this.backgroundColor, required this.color, this.richText, this.bold = true});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(height: 54, width: double.infinity,  child: ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
          WidgetStateProperty.all<Color>(backgroundColor),
          shape: WidgetStateProperty.all<
              RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(30)),
              ))),
      onPressed: onPressed,
      child: title != null ?  Text( title!,
        style:  TextStyle(
            color: color,
            fontWeight: (bold!) ?  FontWeight.bold: FontWeight.normal),
      ): richText!,
    ));

  }

}