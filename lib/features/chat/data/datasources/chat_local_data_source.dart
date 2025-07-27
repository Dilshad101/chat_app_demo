import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/chat_message.dart';
import '../models/users_listing_model.dart';

abstract class ChatLocalDataSource {
  /// Gets cached chat messages.
  ///
  /// Throws [CacheException] if no cached messages exist.
  Future<List<ChatMessage>> getCachedMessages();

  /// Gets all messages exchanged between [userA] and [userB].
  Future<List<ChatMessage>> getMessagesForChat(String userA, String userB);

  /// Caches a single chat message.
  Future<void> cacheMessage(ChatMessage message);

  /// Gets a user profile by ID.
  ///
  /// Throws [CacheException] if no profile is cached.
  Future<User> getCachedUserProfile(String userId);
  Future<List<User>> getAllCachedUserProfile();

  /// Caches a user profile.
  Future<void> cacheUserProfile(User profile);
}

const String CHAT_BOX = 'chat_messages';
const String USER_BOX = 'user_profiles';

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final Box<ChatMessage> chatBox;
  final Box<User> userBox;

  ChatLocalDataSourceImpl({required this.chatBox, required this.userBox});

  @override
  Future<void> cacheMessage(ChatMessage message) async {
    await chatBox.put(message.id, message);
  }

  @override
  Future<List<ChatMessage>> getCachedMessages() async {
    final messages = chatBox.values.toList();
    if (messages.isNotEmpty) {
      return messages;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<ChatMessage>> getMessagesForChat(
      String userA, String userB) async {
    final filtered = chatBox.values
        .where((m) => (m.senderId == userA && m.receiverId == userB) ||
            (m.senderId == userB && m.receiverId == userA))
        .toList();
    return filtered;
  }

  @override
  Future<void> cacheUserProfile(User profile) async {
    await userBox.put(profile.id, profile);
  }

  @override
  Future<User> getCachedUserProfile(String userId) async {
    final profile = userBox.get(userId);
    if (profile != null) {
      return profile;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<User>> getAllCachedUserProfile() async {
    final profile = userBox.values.toList();
    return profile;
  }
}
