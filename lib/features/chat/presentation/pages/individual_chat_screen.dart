import 'package:flutter/material.dart';

import '../../../injection_container.dart';
import '../../../core/local/local_storage.dart';
import '../../data/models/chat_message.dart';
import '../widgets/individual_chat_screen_widget/chat_app_bar.dart';
import '../widgets/individual_chat_screen_widget/chat_input_area.dart';
import '../widgets/individual_chat_screen_widget/chat_messages_list.dart';
import '../widgets/individual_chat_screen_widget/message.dart';

class IndividualChatScreen extends StatefulWidget {
  final String contactName;
  final String contactAvatar;

  const IndividualChatScreen({
    super.key,
    required this.contactName,
    required this.contactAvatar,
  });

  @override
  _IndividualChatScreenState createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  int _messageCounter = 0;
  late HiveService hiveService;

  final List<String> _responses = [
    "That's a great question! Let me think about that for a moment.",
    "I'd be happy to help you with that. Here's what I think...",
    "I can definitely assist you with this.",
    "That's a wonderful idea! Let me break this down for you.",
    "I understand what you're looking for. Here's my suggestion...",
    "Perfect! I have some thoughts on this topic.",
    "Great choice! Let me walk you through this step by step.",
  ];

  @override
  void initState() {
    super.initState();
    hiveService = locator<HiveService>();
    _loadMessages();
    _initializeChat();
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

  void _initializeChat() {
    _messages.addAll([
      Message(
        text: "Hello! I'm Claude, your AI assistant. How can I help you today?",
        isSent: false,
        time: "2:30 PM",
        tickStatus: TickStatus.none,
      ),
      Message(
        text: "Hi there! Can you help me with some coding questions?",
        isSent: true,
        time: "2:31 PM",
        tickStatus: TickStatus.blue,
      ),
      Message(
        text: "I'm working on a Flutter project",
        isSent: true,
        time: "2:31 PM",
        tickStatus: TickStatus.blue,
      ),
      Message(
        text: "Can you review my code?",
        isSent: true,
        time: "2:32 PM",
        tickStatus: TickStatus.blue,
      ),
      Message(
        text:
            "Absolutely! I'd be happy to help you with Flutter. What specific part of your project are you working on?",
        isSent: false,
        time: "2:32 PM",
        tickStatus: TickStatus.none,
      ),
    ]);
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

    _messageController.clear();

    // Simulate AI response
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _messages.add(
          Message(
            text: _responses[DateTime.now().millisecond % _responses.length],
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
          message: _responses[DateTime.now().millisecond % _responses.length],
          timestamp: DateTime.now(),
        ),
      );
    });
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

  String _getCurrentTime() {
    DateTime now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: ChatAppBar(
        contactName: widget.contactName,
        contactAvatar: widget.contactAvatar,
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessagesList(messages: _messages)),
          ChatInputArea(
            controller: _messageController,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
