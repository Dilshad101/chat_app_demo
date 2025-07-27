import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/chat/presentation/pages/chat_screen.dart';
import 'features/chat/presentation/bloc/bloc/fetch_all_users_bloc.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependency();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      home: BlocProvider(
        create: (_) => locator<UserBloc>()..add(const GetAllUsersEvent()),
        child: const ChatScreen(),
      ),
    );
  }
}
