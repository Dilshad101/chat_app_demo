import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  final String avatar;
  final String name;
  final double size;
  final double fontSize;

  const ChatAvatar({
    super.key,
    required this.avatar,
    required this.name,
    this.size = 48,
    this.fontSize = 14,
  });

  Color getAvatarColor(String name) {
    final colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: getAvatarColor(name),
        shape: BoxShape.circle,
      ),
      child: Center(child: Image.network(avatar)),
    );
  }
}
