import 'dart:ui';

class MenuItem {
  final String label;
  final String title;
  final String icon;
  final double size;
  final Color selected;
  final Color normal;
  final bool showLabel;

  MenuItem({
    required this.label,
    required this.title,
    required this.icon,
    required this.size,
    required this.selected,
    required this.normal,
    required this.showLabel,
  });
}

