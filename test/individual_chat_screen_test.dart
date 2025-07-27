import 'package:chat_app_1/core/network/websocket_service.dart';
import 'package:chat_app_1/features/chat/presentation/pages/individual_chat_screen.dart';
import 'package:chat_app_1/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:chat_app_1/injection_container.dart';
import 'fake_chat_local_data_source.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';


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
    if (!locator.isRegistered<ChatLocalDataSource>()) {
      locator.registerSingleton<ChatLocalDataSource>(FakeChatLocalDataSource());
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
