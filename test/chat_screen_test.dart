import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app_1/features/chat/data/models/users_listing_model.dart';
import 'package:chat_app_1/features/chat/presentation/bloc/bloc/fetch_all_users_bloc.dart';
import 'package:chat_app_1/features/chat/presentation/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

class FakeUserEvent extends Fake implements UserEvent {}

class FakeUserState extends Fake implements UserState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserEvent());
    registerFallbackValue(FakeUserState());
  });

  testWidgets('ChatScreen displays users list', (tester) async {
    final mockBloc = MockUserBloc();
    final users = UsersListingModel(users: [
      const User(name: 'Jane', avatar: 'a.png', id: 1),
      const User(name: 'John', avatar: 'b.png', id: 2),
    ]);

    whenListen(
      mockBloc,
      Stream<UserState>.fromIterable([UserLoaded(usersListing: users)]),
      initialState: UserLoaded(usersListing: users),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<UserBloc>.value(
          value: mockBloc,
          child: const ChatScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Jane'), findsOneWidget);
    expect(find.text('John'), findsOneWidget);
  });
}
