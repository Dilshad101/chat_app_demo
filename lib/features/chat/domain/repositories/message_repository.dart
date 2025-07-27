import '../../data/models/chat_message.dart';
import '../../../../core/network/websocket_service.dart';

abstract class MessageRepository {
  Stream<String> get messages;
  Stream<WsConnectionStatus> get connectionStatus;
  Future<List<ChatMessage>> getMessagesForChat(String userA, String userB);
  Future<void> sendMessage(ChatMessage message);
  Future<void> saveMessage(ChatMessage message);
  void connect();
  void disconnect();
}
