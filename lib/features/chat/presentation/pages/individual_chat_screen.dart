import 'package:flutter/material.dart';

import 'dart:async';

import '../../../../core/local/local_storage.dart';
import '../../../../core/network/websocket_service.dart';
import '../../../../injection_container.dart';
import '../../data/models/chat_message.dart';
import '../widgets/individual_chat_screen_widget/chat_app_bar.dart';
import '../widgets/individual_chat_screen_widget/chat_input_area.dart';
import '../widgets/individual_chat_screen_widget/chat_messages_list.dart';
import '../widgets/individual_chat_screen_widget/message.dart';

class IndividualChatScreen extends StatefulWidget {
  final String contactName;
  final String contactAvatar;
  final WebSocketService? webSocketService;

  const IndividualChatScreen({
    super.key,
    required this.contactName,
    required this.contactAvatar,
    this.webSocketService,
  });

  @override
  _IndividualChatScreenState createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  int _messageCounter = 0;
  late HiveService hiveService;
  late WebSocketService _wsService;
  late StreamSubscription<WsConnectionStatus> _connectionSubscription;
  late StreamSubscription<String> _messagesSubscription;
  bool _wsConnected = false;
  bool _showTyping = false;

  @override
  void initState() {
    super.initState();
    hiveService = locator<HiveService>();
    _wsService = widget.webSocketService ?? locator<WebSocketService>();
    _wsService.connect();
    _connectionSubscription = _wsService.connectionStatus.listen((status) {
      if (!mounted) return;
      setState(() {
        _wsConnected = status == WsConnectionStatus.connected;
      });
    });
    _messagesSubscription = _wsService.messages.listen((message) {
      if (message == '__typing__') {
        _startTypingIndicator();
      } else {
        if (!mounted) return;
        setState(() {
          _messages.add(
            Message(
              text: message,
              isSent: false,
              time: _getCurrentTime(),
              tickStatus: TickStatus.none,
            ),
          );
          _updateTickStatuses();
        });
        hiveService.saveMessage(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: 'bot',
            receiverId: 'user',
            message: message,
            timestamp: DateTime.now(),
          ),
        );
      }
    });
    _loadMessages();
  }

  void _loadMessages() {
    final cached = hiveService.getAllMessages();
    for (final m in cached) {
      _messages.add(
        Message(
          text: m.message,
          isSent: m.senderId == 'user',
          time:
              "${m.timestamp.hour}:${m.timestamp.minute.toString().padLeft(2, '0')}",
          tickStatus: TickStatus.none,
        ),
      );
    }
    _messageCounter = _messages.where((m) => m.isSent).length;
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        Message(
          text: _messageController.text.trim(),
          isSent: true,
          time: _getCurrentTime(),
          tickStatus: TickStatus.single,
        ),
      );
      _messageCounter++;
      _updateTickStatuses();
    });

    hiveService.saveMessage(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'user',
        receiverId: 'bot',
        message: _messageController.text.trim(),
        timestamp: DateTime.now(),
      ),
    );

    _wsService.send(_messageController.text.trim());

    _messageController.clear();
  }

  void _updateTickStatuses() {
    List<Message> sentMessages = _messages.where((m) => m.isSent).toList();
    for (int i = 0; i < sentMessages.length; i++) {
      Message message = sentMessages[i];
      int messageIndex = _messages.indexOf(message);

      if (i == sentMessages.length - 1) {
        _messages[messageIndex] = message.copyWith(
          tickStatus: TickStatus.single,
        );
      } else if (i == sentMessages.length - 2) {
        _messages[messageIndex] = message.copyWith(
          tickStatus: TickStatus.double,
        );
      } else {
        _messages[messageIndex] = message.copyWith(tickStatus: TickStatus.blue);
      }
    }
  }

  void _startTypingIndicator() {
    setState(() {
      _showTyping = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showTyping = false;
        });
      }
    });
  }

  String _getCurrentTime() {
    DateTime now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  void _onTyping(String text) {
    _wsService.send('__typing__');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: ChatAppBar(
        contactName: widget.contactName,
        contactAvatar: widget.contactAvatar,
        isConnected: _wsConnected,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: ChatMessagesList(messages: _messages)),
            if (_showTyping)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('${widget.contactName} is typing...'),
              ),
            ChatInputArea(
              controller: _messageController,
              onSendMessage: _sendMessage,
              onChanged: _onTyping,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _connectionSubscription.cancel();
    _messagesSubscription.cancel();
    _wsService.disconnect();
    super.dispose();
  }
}
