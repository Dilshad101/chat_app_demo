import 'package:flutter/material.dart';

import '../chat_screen_widgets/chat_avatar.dart';
import '../chat_screen_widgets/connection_status.dart';
import '../../../../../core/network/websocket_service.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String contactName;
  final String contactAvatar;
  final WsConnectionStatus status;

  const ChatAppBar({
    super.key,
    required this.contactName,
    required this.contactAvatar,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF4A76A8),
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          ChatAvatar(
            avatar: contactAvatar,
            name: contactName,
            size: 40,
            fontSize: 16,
          ),
          SizedBox(width: 12),
          Text(
            contactName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: ConnectionStatus(status: status),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
