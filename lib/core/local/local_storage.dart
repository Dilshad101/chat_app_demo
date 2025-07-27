import 'package:hive_flutter/hive_flutter.dart';

import '../../features/chat/data/models/chat_message.dart';
import '../../features/chat/data/models/users_listing_model.dart';

abstract class HiveService {
  Future<void> init();
  Future<void> saveMessage(ChatMessage message);
  List<ChatMessage> getAllMessages();
  List<ChatMessage> getMessagesForChat(String userA, String userB);
  Future<void> clearMessages();
  Future<void> saveUser(User profile);
  User? getUser(String userId);
  Future<void> clearUsers();
}

class HiveServiceImpl extends HiveService {
  static const String chatBoxName = 'chat_messages';
  static const String userBoxName = 'user_profiles';

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ChatMessageAdapter());
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<ChatMessage>(chatBoxName);
    await Hive.openBox<User>(userBoxName);
  }

  // Chat Message Methods
  @override
  Future<void> saveMessage(ChatMessage message) async {
    final box = Hive.box<ChatMessage>(chatBoxName);
    await box.put(message.id, message);
  }

  @override
  List<ChatMessage> getAllMessages() {
    final box = Hive.box<ChatMessage>(chatBoxName);
    return box.values.toList();
  }

  @override
  List<ChatMessage> getMessagesForChat(String userA, String userB) {
    final box = Hive.box<ChatMessage>(chatBoxName);
    return box.values
        .where((m) => (m.senderId == userA && m.receiverId == userB) ||
            (m.senderId == userB && m.receiverId == userA))
        .toList();
  }

  @override
  Future<void> clearMessages() async {
    await Hive.box<ChatMessage>(chatBoxName).clear();
  }

  // User Profile Methods
  @override
  Future<void> saveUser(User profile) async {
    final box = Hive.box<User>(userBoxName);
    await box.put(profile.id, profile);
  }

  @override
  User? getUser(String userId) {
    final box = Hive.box<User>(userBoxName);
    return box.get(userId);
  }

  @override
  Future<void> clearUsers() async {
    await Hive.box<User>(userBoxName).clear();
  }
}
