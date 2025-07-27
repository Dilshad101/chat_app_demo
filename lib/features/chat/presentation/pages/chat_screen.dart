import 'package:chat_app_1/features/chat/data/models/users_listing_model.dart';
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

  ///TODO: fetch users from local or api
  final UsersListingModel usersModel = UsersListingModel(users: []);

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
                    itemCount: usersModel.users?.length ?? 0,
                    separatorBuilder: (context, index) =>
                        Divider(height: 1, color: Colors.grey.shade100),
                    itemBuilder: (context, index) {
                      final user = usersModel.users?[index];
                      return ChatListItem(
                        user: user,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return IndividualChatScreen(
                                  contactName: user?.name ?? '',
                                  contactAvatar: user?.profileImage ?? '',
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
