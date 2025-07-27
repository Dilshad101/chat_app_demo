import 'package:flutter/material.dart';
import 'send_button.dart';

class ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSendMessage;
  final ValueChanged<String>? onChanged;

  const ChatInputArea({
    Key? key,
    required this.controller,
    required this.onSendMessage,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFE1E8ED)),
              ),
              child: Row(
                children: [
              SizedBox(width: 5,),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                      ),
                      onChanged: onChanged,
                      onSubmitted: (_) => onSendMessage(),
                    ),
                  ),
                
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          SendButton(onPressed: onSendMessage),
        ],
      ),
    );
  }
}