import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/network/websocket_service.dart';
import '../../../data/models/chat_message.dart';
import '../../../domain/usecases/get_messages_for_chat.dart';
import '../../../domain/usecases/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessagesForChat getMessages;
  final SendMessage sendMessage;
  final Stream<String> messagesStream;
  final Stream<WsConnectionStatus> statusStream;
  final String userId;
  final String contactId;

  StreamSubscription<String>? _messagesSub;
  StreamSubscription<WsConnectionStatus>? _statusSub;

  ChatBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.messagesStream,
    required this.statusStream,
    required this.userId,
    required this.contactId,
  }) : super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<ChatMessageSent>(_onSend);
    on<_IncomingMessage>(_onIncoming);
    on<_StatusChanged>(_onStatusChanged);
    on<_ShowTyping>(_onShowTyping);
  }

  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    final result = await getMessages(ChatParams(userA: userId, userB: contactId));
    result.fold((failure) {}, (messages) {
      final msgs = messages
          .map((m) => Message(
                text: m.message,
                isSent: m.senderId == userId,
                time:
                    "${m.timestamp.hour}:${m.timestamp.minute.toString().padLeft(2, '0')}",
                tickStatus: TickStatus.none,
              ))
          .toList();
      emit(state.copyWith(messages: msgs));
    });
    _messagesSub = messagesStream.listen((event) {
      if (event == '__typing__') {
        add(const _ShowTyping());
      } else if (!event.contains('sponsored by Lob.com')) {
        add(_IncomingMessage(event));
      }
    });
    _statusSub = statusStream.listen((status) {
      add(_StatusChanged(status));
    });
  }

  Future<void> _onSend(ChatMessageSent event, Emitter<ChatState> emit) async {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: userId,
      receiverId: contactId,
      message: event.text.trim(),
      timestamp: DateTime.now(),
    );
    await sendMessage(message);
    final msgs = List<Message>.from(state.messages)
      ..add(Message(
          text: event.text.trim(),
          isSent: true,
          time:
              "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}",
          tickStatus: TickStatus.single));
    emit(state.copyWith(messages: _updateTickStatuses(msgs)));
  }

  void _onIncoming(_IncomingMessage event, Emitter<ChatState> emit) {
    final msg = Message(
      text: event.text,
      isSent: false,
      time: _timeNow(),
      tickStatus: TickStatus.none,
    );
    final msgs = List<Message>.from(state.messages)..add(msg);
    emit(state.copyWith(messages: _updateTickStatuses(msgs), showTyping: false));
  }

  void _onStatusChanged(_StatusChanged event, Emitter<ChatState> emit) {
    emit(state.copyWith(status: event.status));
  }

  void _onShowTyping(_ShowTyping event, Emitter<ChatState> emit) {
    emit(state.copyWith(showTyping: true));
  }

  List<Message> _updateTickStatuses(List<Message> messages) {
    final sent = messages.where((m) => m.isSent).toList();
    for (int i = 0; i < sent.length; i++) {
      final message = sent[i];
      final index = messages.indexOf(message);
      if (i == sent.length - 1) {
        messages[index] = message.copyWith(tickStatus: TickStatus.single);
      } else if (i == sent.length - 2) {
        messages[index] = message.copyWith(tickStatus: TickStatus.double);
      } else {
        messages[index] = message.copyWith(tickStatus: TickStatus.blue);
      }
    }
    return messages;
  }

  String _timeNow() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    _statusSub?.cancel();
    return super.close();
  }
}
