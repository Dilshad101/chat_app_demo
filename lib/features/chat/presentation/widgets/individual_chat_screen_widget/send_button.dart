import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SendButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Color(0xFF0084FF),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.send, color: Colors.white, size: 16),
        onPressed: onPressed,
      ),
    );
  }
}