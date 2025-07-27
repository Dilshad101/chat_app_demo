import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/network_info.dart';
import '../../../../injection_container.dart';
import '../bloc/bloc/fetch_all_users_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    locator<NetworkInfo>().isConnected.then((value) {
      setState(() {
        isConnected = value;
      });
    });
  }

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
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is UserLoaded) {
                        final users = state.usersListing.users;
                        return ListView.separated(
                          itemCount: users.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 1, color: Colors.grey.shade100),
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return ChatListItem(
                              user: user,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return IndividualChatScreen(
                                        contactName: user.name,
                                        contactAvatar: user.avatar,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else if (state is UserError) {
                        return Center(child: Text(state.message));
                      } else {
                        return const SizedBox();
                      }
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
