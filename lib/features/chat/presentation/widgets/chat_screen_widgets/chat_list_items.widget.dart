import 'package:chat_app_1/features/chat/data/models/users_listing_model.dart';
import 'package:flutter/material.dart';

import 'chat_avatar.dart';

class ChatListItem extends StatelessWidget {
  final User? user;
  final VoidCallback onTap;

  const ChatListItem({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            ChatAvatar(avatar: user?.avatar ?? '', name: user?.name ?? ''),
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
                          user?.name ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
