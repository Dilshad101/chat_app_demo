part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  const ChatStarted();
}

class ChatMessageSent extends ChatEvent {
  final String text;
  const ChatMessageSent(this.text);
  @override
  List<Object?> get props => [text];
}

class _IncomingMessage extends ChatEvent {
  final String text;
  const _IncomingMessage(this.text);
  @override
  List<Object?> get props => [text];
}

class _StatusChanged extends ChatEvent {
  final WsConnectionStatus status;
  const _StatusChanged(this.status);
  @override
  List<Object?> get props => [status];
}

class _ShowTyping extends ChatEvent {
  const _ShowTyping();
}
