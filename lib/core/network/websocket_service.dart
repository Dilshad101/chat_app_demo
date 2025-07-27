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
  WsConnectionStatus _currentStatus = WsConnectionStatus.connecting;

  Stream<String> get messages => _messageController.stream;
  Stream<WsConnectionStatus> get connectionStatus async* {
    yield _currentStatus;
    yield* _connectionController.stream;
  }

  WebSocketService({required this.url, this.channelFactory});

  void connect() {
    if (_channel != null) return;
    _currentStatus = WsConnectionStatus.connecting;
    _connectionController.add(_currentStatus);
    try {
      final connect = channelFactory ??
          ((uri) => WebSocketChannel.connect(uri));
      _channel = connect(Uri.parse(url));
      _currentStatus = WsConnectionStatus.connected;
      _connectionController.add(_currentStatus);
      _channel!.stream.listen((event) {
        _messageController.add(event);
      }, onError: (_) {
        _currentStatus = WsConnectionStatus.disconnected;
        _connectionController.add(_currentStatus);
      }, onDone: () {
        _currentStatus = WsConnectionStatus.disconnected;
        _connectionController.add(_currentStatus);
        _channel = null;
      });
    } catch (e) {
      _currentStatus = WsConnectionStatus.disconnected;
      _connectionController.add(_currentStatus);
      _channel = null;
    }
  }

  void send(String message) {
    _channel?.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _currentStatus = WsConnectionStatus.disconnected;
    _connectionController.add(_currentStatus);
  }
}
