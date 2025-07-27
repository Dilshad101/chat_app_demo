import 'package:flutter/material.dart';

import '../widgets/chat_screen_widgets/chat_header.dart';
import '../widgets/chat_screen_widgets/chat_list_items.widget.dart';
import 'individual_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  bool isConnected = true;
  ChatItem? selectedChat;

  final List<ChatItem> chatList = [
    ChatItem(id: 3, name: "Rose Carr", avatar: "RC"),
    ChatItem(id: 4, name: "Manuel Clayton", avatar: "MC"),
    ChatItem(id: 5, name: "Dev Team Alja", avatar: "TA"),
    ChatItem(id: 6, name: "Rosetta Roberts", avatar: "RR"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // App Header
                AppHeader(isConnected: isConnected),

                // Chat List
                Expanded(
                  child: ListView.separated(
                    itemCount: chatList.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 1, color: Colors.grey.shade100),
                    itemBuilder: (context, index) {
                      final chat = chatList[index];
                      return ChatListItem(
                        chat: chat,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return IndividualChatScreen(
                                  contactName: chat.name,
                                  contactAvatar: chat.avatar,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatItem {
  final int id;
  final String name;

  final String avatar;

  ChatItem({required this.id, required this.name, required this.avatar});
}
