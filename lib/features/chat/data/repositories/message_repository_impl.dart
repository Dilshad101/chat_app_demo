import '../../../../core/network/websocket_service.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../models/chat_message.dart';

class MessageRepositoryImpl implements MessageRepository {
  final ChatLocalDataSource localDataSource;
  final WebSocketService webSocketService;

  MessageRepositoryImpl({required this.localDataSource, required this.webSocketService});

  @override
  Stream<String> get messages => webSocketService.messages;

  @override
  Stream<WsConnectionStatus> get connectionStatus => webSocketService.connectionStatus;

  @override
  Future<List<ChatMessage>> getMessagesForChat(String userA, String userB) async {
    return localDataSource.getMessagesForChat(userA, userB);
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    await localDataSource.cacheMessage(message);
    webSocketService.send(message.message);
  }

  @override
  Future<void> saveMessage(ChatMessage message) async {
    await localDataSource.cacheMessage(message);
  }

  @override
  void connect() => webSocketService.connect();

  @override
  void disconnect() => webSocketService.disconnect();
}
