import 'package:chat_app_1/core/local/local_storage.dart';
import 'package:chat_app_1/core/network/websocket_service.dart';
import 'package:chat_app_1/features/chat/presentation/pages/individual_chat_screen.dart';
import 'package:chat_app_1/features/chat/data/models/chat_message.dart';
import 'package:chat_app_1/features/chat/data/models/users_listing_model.dart';
import 'package:chat_app_1/injection_container.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class FakeHiveService extends Fake implements HiveService {
  final List<ChatMessage> stored = [];

  @override
  Future<void> init() async {}

  @override
  List<ChatMessage> getAllMessages() => [];

  @override
  List<ChatMessage> getMessagesForChat(String userA, String userB) => [];

  @override
  Future<void> saveMessage(ChatMessage message) async {
    stored.add(message);
  }

  @override
  Future<void> clearMessages() async {}

  @override
  Future<void> saveUser(User profile) async {}

  @override
  User? getUser(String userId) => null;

  @override
  Future<void> clearUsers() async {}
}

class FakeWebSocketService extends WebSocketService {
  FakeWebSocketService() : super(url: 'ws://test');
  final List<String> sent = [];
  final StreamController<String> _controller = StreamController.broadcast();
  final StreamController<WsConnectionStatus> _status =
      StreamController<WsConnectionStatus>.broadcast();

  @override
  Stream<String> get messages => _controller.stream;

  @override
  Stream<WsConnectionStatus> get connectionStatus => _status.stream;

  @override
  void connect() {
    _status.add(WsConnectionStatus.connected);
  }

  @override
  void send(String message) {
    sent.add(message);
  }

  void emit(String msg) => _controller.add(msg);

  @override
  void disconnect() {
    _status.add(WsConnectionStatus.disconnected);
  }
}

void main() {
  final locator = GetIt.instance;

  setUp(() {
    if (!locator.isRegistered<HiveService>()) {
      locator.registerSingleton<HiveService>(FakeHiveService());
    }
  });

  testWidgets('shows connection indicator and sends message', (tester) async {
    final ws = FakeWebSocketService();
    await tester.pumpWidget(
      MaterialApp(
        home: IndividualChatScreen(
          contactName: 'Bot',
          contactAvatar: 'a.png',
          contactId: 1,
          webSocketService: ws,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Active'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'hi');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(ws.sent, contains('hi'));
  });

  testWidgets('shows typing indicator on incoming typing event', (
    tester,
  ) async {
    final ws = FakeWebSocketService();
    await tester.pumpWidget(
      MaterialApp(
        home: IndividualChatScreen(
          contactName: 'Bot',
          contactAvatar: 'a.png',
          contactId: 1,
          webSocketService: ws,
        ),
      ),
    );
    await tester.pump();

    ws.emit('__typing__');
    await tester.pump();
    expect(find.text('Bot is typing...'), findsOneWidget);
  });
}
