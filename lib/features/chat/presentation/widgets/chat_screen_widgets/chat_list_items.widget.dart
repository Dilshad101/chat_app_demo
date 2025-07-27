import 'package:flutter/material.dart';

import '../../pages/chat_screen.dart';
import 'chat_avatar.dart';
import 'count_widget.dart';

class ChatListItem extends StatelessWidget {
  final ChatItem chat;
  final VoidCallback onTap;

  const ChatListItem({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            ChatAvatar(avatar: chat.avatar, name: chat.name),
            SizedBox(width: 12),

            // Chat Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        chat.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    chat.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            // Pending Count Badge
            if (chat.pendingCount > 0) ...[
              SizedBox(width: 12),
              PendingCountBadge(count: chat.pendingCount),
            ],
          ],
        ),
      ),
    );
  }
}
