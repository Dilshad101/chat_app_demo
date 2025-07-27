import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/websocket_service.dart';
import '../../../../injection_container.dart';
import '../bloc/bloc/fetch_all_users_bloc.dart';
import '../widgets/chat_screen_widgets/chat_header.dart';
import '../widgets/chat_screen_widgets/chat_list_items.widget.dart';
import '../widgets/chat_screen_widgets/connection_status.dart';
import 'individual_chat_screen.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late WebSocketService _wsService;
  ChatItem? selectedChat;
  late StreamSubscription<WsConnectionStatus> _connectionSubscription;
  WsConnectionStatus _wsStatus = WsConnectionStatus.connecting;

  @override
  void initState() {
    super.initState();
    _wsService = locator<WebSocketService>();
    _wsService.connect();
    _connectionSubscription = _wsService.connectionStatus.listen((status) {
      if (!mounted) return;
      setState(() {
        _wsStatus = status;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // App Header
                const AppHeader(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConnectionStatus(status: _wsStatus),
                ),

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
                                        contactId: user.id,
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    _wsService.disconnect();
    super.dispose();
  }
}

class ChatItem {
  final int id;
  final String name;

  final String avatar;

  ChatItem({required this.id, required this.name, required this.avatar});
}
