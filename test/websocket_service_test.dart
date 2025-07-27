import 'dart:async';

import 'package:chat_app_1/core/network/websocket_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockWebSocketChannel extends Mock implements WebSocketChannel {}
class MockWebSocketSink extends Mock implements WebSocketSink {}

void main() {
  late MockWebSocketChannel channel;
  late MockWebSocketSink sink;

  setUp(() {
    channel = MockWebSocketChannel();
    sink = MockWebSocketSink();
    when(() => channel.sink).thenReturn(sink);
    when(() => channel.stream).thenAnswer((_) => const Stream.empty());
  });

  test('send forwards message to sink', () {
    final service = WebSocketService(url: 'ws://test', channelFactory: (_) => channel);
    service.connect();

    service.send('hello');

    verify(() => sink.add('hello')).called(1);
  });

  test('messages are forwarded from stream', () async {
    final controller = StreamController<String>();
    when(() => channel.stream).thenAnswer((_) => controller.stream);
    final service = WebSocketService(url: 'ws://test', channelFactory: (_) => channel);
    final received = <String>[];
    service.messages.listen(received.add);

    service.connect();
    controller.add('hi');
    await Future.delayed(Duration.zero);

    expect(received, ['hi']);
  });
}
