import 'package:flutter/material.dart';
import 'message.dart';
import 'message_footer.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: message.isSent ? Color(0xFF0084FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: message.isSent ? null : Border.all(color: Color(0xFFE1E8ED)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isSent ? Colors.white : Color(0xFF333333),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            SizedBox(height: 4),
            MessageFooter(
              time: message.time,
              tickStatus: message.tickStatus,
              isSent: message.isSent,
            ),
          ],
        ),
      ),
    );
  }
}
