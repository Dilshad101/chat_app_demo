import 'package:flutter/material.dart';

import 'message.dart';

class TickIcon extends StatelessWidget {
  final TickStatus tickStatus;

  const TickIcon({super.key, required this.tickStatus});

  @override
  Widget build(BuildContext context) {
    Color color;
    String icon;

    switch (tickStatus) {
      case TickStatus.single:
        color = const Color.fromARGB(255, 255, 255, 255);
        icon = '✓';
        break;
      case TickStatus.double:
        color = Colors.grey[400]!;
        icon = '✓✓';
        break;
      case TickStatus.blue:
        color = Color.fromARGB(255, 254, 254, 254);
        icon = '✓✓';
        break;
      default:
        return SizedBox.shrink();
    }

    return Text(icon, style: TextStyle(color: color, fontSize: 12));
  }
}
