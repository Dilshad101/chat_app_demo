import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/websocket_service.dart';
import '../../../../injection_container.dart';
import '../../data/repositories/message_repository_impl.dart';
import '../../domain/usecases/get_messages_for_chat.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/save_message.dart';
import '../bloc/chat/chat_bloc.dart';
import '../widgets/individual_chat_screen_widget/chat_app_bar.dart';
import '../widgets/individual_chat_screen_widget/chat_input_area.dart';
import '../widgets/individual_chat_screen_widget/chat_messages_list.dart';
import '../widgets/individual_chat_screen_widget/message.dart';

class IndividualChatScreen extends StatefulWidget {
  final String contactName;
  final String contactAvatar;
  final int contactId;
  final WebSocketService? webSocketService;

  const IndividualChatScreen({
    super.key,
    required this.contactName,
    required this.contactAvatar,
    required this.contactId,
    this.webSocketService,
  });

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late ChatBloc _bloc;
  late MessageRepositoryImpl _repository;
  late WebSocketService _wsService;

  @override
  void initState() {
    super.initState();
    _wsService = widget.webSocketService ?? locator<WebSocketService>();
    _repository = MessageRepositoryImpl(
      localDataSource: locator(),
      webSocketService: _wsService,
    );
    _bloc = ChatBloc(
      getMessages: GetMessagesForChat(_repository),
      sendMessage: SendMessage(_repository),
      saveMessage: SaveMessage(_repository),
      messagesStream: _repository.messages,
      statusStream: _repository.connectionStatus,
      userId: 'user',
      contactId: widget.contactId.toString(),
    );
    _repository.connect();
    _bloc.add(const ChatStarted());
  }

  void _onSendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    _bloc.add(ChatMessageSent(_messageController.text.trim()));
    _messageController.clear();
  }

  void _onTyping(String text) {
    _wsService.send('__typing__');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            appBar: ChatAppBar(
              contactName: widget.contactName,
              contactAvatar: widget.contactAvatar,
              status: state.status,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(child: ChatMessagesList(messages: state.messages)),
                  if (state.showTyping)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('${widget.contactName} is typing...'),
                    ),
                  ChatInputArea(
                    controller: _messageController,
                    onSendMessage: _onSendMessage,
                    onChanged: _onTyping,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    _repository.disconnect();
    _messageController.dispose();
    super.dispose();
  }
}
