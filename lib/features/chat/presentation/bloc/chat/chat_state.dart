part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<Message> messages;
  final WsConnectionStatus status;
  final bool showTyping;
  const ChatState({
    this.messages = const [],
    this.status = WsConnectionStatus.connecting,
    this.showTyping = false,
  });

  ChatState copyWith({
    List<Message>? messages,
    WsConnectionStatus? status,
    bool? showTyping,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      showTyping: showTyping ?? this.showTyping,
    );
  }

  @override
  List<Object?> get props => [messages, status, showTyping];
}
