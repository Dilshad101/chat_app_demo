import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WsConnectionStatus { connecting, connected, disconnected }

class WebSocketService {
  final String url;
  final WebSocketChannel Function(Uri url)? channelFactory;
  WebSocketChannel? _channel;
  final _messageController = StreamController<String>.broadcast();
  final _connectionController =
      StreamController<WsConnectionStatus>.broadcast();

  Stream<String> get messages => _messageController.stream;
  Stream<WsConnectionStatus> get connectionStatus =>
      _connectionController.stream;

  WebSocketService({required this.url, this.channelFactory});

  void connect() {
    if (_channel != null) return;
    _connectionController.add(WsConnectionStatus.connecting);
    try {
      final connect = channelFactory ??
          ((uri) => WebSocketChannel.connect(uri));
      _channel = connect(Uri.parse(url));
      _connectionController.add(WsConnectionStatus.connected);
      _channel!.stream.listen((event) {
        _messageController.add(event);
      }, onError: (_) {
        _connectionController.add(WsConnectionStatus.disconnected);
      }, onDone: () {
        _connectionController.add(WsConnectionStatus.disconnected);
        _channel = null;
      });
    } catch (e) {
      _connectionController.add(WsConnectionStatus.disconnected);
      _channel = null;
    }
  }

  void send(String message) {
    _channel?.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _connectionController.add(WsConnectionStatus.disconnected);
  }
}
