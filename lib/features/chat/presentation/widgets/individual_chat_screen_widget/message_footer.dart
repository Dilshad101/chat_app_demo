import 'package:flutter/material.dart';

import 'message.dart';
import 'tick_icon.dart';

class MessageFooter extends StatelessWidget {
  final String time;
  final TickStatus tickStatus;
  final bool isSent;

  const MessageFooter({
    super.key,
    required this.time,
    required this.tickStatus,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isSent
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(
            color: isSent ? Colors.white70 : Colors.grey[600],
            fontSize: 11,
          ),
        ),
        if (isSent && tickStatus != TickStatus.none) ...[
          SizedBox(width: 4),
          TickIcon(tickStatus: tickStatus),
        ],
      ],
    );
  }
}
