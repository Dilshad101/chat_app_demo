import 'package:chat_app_1/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:chat_app_1/features/chat/data/models/chat_message.dart';
import 'package:chat_app_1/features/chat/data/models/users_listing_model.dart';

class FakeChatLocalDataSource implements ChatLocalDataSource {
  final List<ChatMessage> storedMessages = [];
  @override
  Future<void> cacheMessage(ChatMessage message) async {
    storedMessages.add(message);
  }

  @override
  Future<List<ChatMessage>> getCachedMessages() async => storedMessages;

  @override
  Future<void> cacheUserProfile(User profile) async {}

  @override
  Future<User> getCachedUserProfile(String userId) async {
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getAllCachedUserProfile() async => [];
}
