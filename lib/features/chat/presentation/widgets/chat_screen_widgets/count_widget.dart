import 'package:flutter/material.dart';

class PendingCountBadge extends StatelessWidget {
  final int count;

  const PendingCountBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: BoxConstraints(minWidth: 20, minHeight: 20),
      child: Center(
        child: Text(
          count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
