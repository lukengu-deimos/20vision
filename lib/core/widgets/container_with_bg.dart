import 'package:flutter/material.dart';

class ContainerWithBg extends StatelessWidget {
  final Widget child;
  const ContainerWithBg({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/global-connections@3x.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }

}