import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:data_connection_checker_tv/data_connection_checker.dart';

import 'core/local/local_storage.dart';
import 'core/network/network_info.dart';
import 'features/chat/data/datasources/chat_local_data_source.dart';
import 'features/chat/data/datasources/number_trivia_remote_data_source.dart';
import 'features/chat/data/models/chat_message.dart';
import 'features/chat/data/models/users_listing_model.dart';
import 'features/chat/data/repositories/user_repository_impl.dart';
import 'features/chat/domain/repositories/user_repository.dart';
import 'features/chat/domain/usecases/get_all_users_usecase.dart';
import 'features/chat/presentation/bloc/bloc/fetch_all_users_bloc.dart';

final locator = GetIt.instance;

GlobalKey<NavigatorState> get navigatorKey =>
    locator<GlobalKey<NavigatorState>>();

Future<void> setupDependency() async {
  final localStorage = HiveServiceImpl();
  await localStorage.init();

  locator.registerSingleton<HiveService>(localStorage);

  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => DataConnectionChecker());
  locator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(locator<DataConnectionChecker>()));

  locator.registerLazySingleton<ChatLocalDataSource>(() => ChatLocalDataSourceImpl(
        chatBox: Hive.box<ChatMessage>(HiveServiceImpl.chatBoxName),
        userBox: Hive.box<User>(HiveServiceImpl.userBoxName),
      ));
  locator.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<UserRepository>(() => UsersRepostoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
        networkInfo: locator(),
      ));
  locator.registerLazySingleton(() => GetAllUsers(locator()));
  locator.registerFactory(() => UserBloc(getAllUsers: locator()));
}
