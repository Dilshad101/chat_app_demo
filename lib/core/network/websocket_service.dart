import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  final WebSocketChannel Function(Uri url)? channelFactory;
  WebSocketChannel? _channel;
  final _messageController = StreamController<String>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<String> get messages => _messageController.stream;
  Stream<bool> get connectionStatus => _connectionController.stream;

  WebSocketService({required this.url, this.channelFactory});

  void connect() {
    try {
      final connect = channelFactory ??
          ((uri) => WebSocketChannel.connect(uri));
      _channel = connect(Uri.parse(url));
      _connectionController.add(true);
      _channel!.stream.listen((event) {
        _messageController.add(event);
      }, onError: (_) {
        _connectionController.add(false);
      }, onDone: () {
        _connectionController.add(false);
      });
    } catch (e) {
      _connectionController.add(false);
    }
  }

  void send(String message) {
    _channel?.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close();
    _connectionController.add(false);
  }
}
