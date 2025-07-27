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
    ChatItem(
      id: 1,
      name: "Loretta Russell",
      message: "Hey did you see how hungry my...",
      time: "9:41 AM",
      avatar: "LR",
      online: true,
      pendingCount: 0,
    ),
    ChatItem(
      id: 2,
      name: "Nina Greer",
      message:
          "I don't think I can join you later on the afternoon since we are meaning...",
      time: "9:35 AM",
      avatar: "NG",
      online: true,
      pendingCount: 2,
    ),
    ChatItem(
      id: 3,
      name: "Rose Carr",
      message: "I think our conversation has become...",
      time: "9:30 AM",
      avatar: "RC",
      online: false,
      pendingCount: 0,
    ),
    ChatItem(
      id: 4,
      name: "Manuel Clayton",
      message: "Can we meet on wednesday night and discuss about new book...",
      time: "Yesterday",
      avatar: "MC",
      online: false,
      pendingCount: 1,
    ),
    ChatItem(
      id: 5,
      name: "Dev Team Alja",
      message:
          "Santiago: When do you want a discussion about our current progress?",
      time: "Yesterday",
      avatar: "TA",
      online: true,
      pendingCount: 5,
    ),
    ChatItem(
      id: 6,
      name: "Rosetta Roberts",
      message:
          "Wow, I don't know. So, yesterday at the club there's was a big vibe.",
      time: "Yesterday",
      avatar: "RR",
      online: true,
      pendingCount: 0,
    ),
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
  final String message;
  final String time;
  final String avatar;
  final bool online;
  final int pendingCount;

  ChatItem({
    required this.id,
    required this.name,
    required this.message,
    required this.time,
    required this.avatar,
    required this.online,
    required this.pendingCount,
  });
}
