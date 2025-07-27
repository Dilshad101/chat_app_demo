import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:chat_app_1/main.dart' as app;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chat_app_1/core/local/local_storage.dart';
import 'package:chat_app_1/features/chat/data/models/chat_message.dart';
import 'package:chat_app_1/features/chat/data/models/users_listing_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('send and receive messages are saved locally', (tester) async {
    await Hive.initFlutter();
    Hive.registerAdapter(ChatMessageAdapter());
    Hive.registerAdapter(UsersListingModelAdapter());
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<ChatMessage>(HiveServiceImpl.chatBoxName);
    await Hive.openBox<User>(HiveServiceImpl.userBoxName);

    app.main();
    await tester.pumpAndSettle();

    // open first chat (using first user name)
    await tester.tap(find.text('Jane').first, warnIfMissed: false);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'hello');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    final box = Hive.box<ChatMessage>(HiveServiceImpl.chatBoxName);
    final sent = box.values.any((m) => m.message == 'hello' && m.senderId == 'user');
    final received = box.values.any((m) => m.message == 'hello' && m.senderId == 'bot');
    expect(sent && received, true);
  });
}
