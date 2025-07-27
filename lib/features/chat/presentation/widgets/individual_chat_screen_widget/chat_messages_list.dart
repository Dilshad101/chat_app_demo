import 'package:flutter/material.dart';

import 'message.dart';
import 'message_bubble.dart';

class ChatMessagesList extends StatelessWidget {
  final List<Message> messages;

  const ChatMessagesList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: MessageBubble(message: messages[index]),
        );
      },
    );
  }
}
