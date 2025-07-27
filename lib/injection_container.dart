import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'core/local/local_storage.dart';

final locator = GetIt.instance;

GlobalKey<NavigatorState> get navigatorKey =>
    locator<GlobalKey<NavigatorState>>();

Future<void> setupDependency() async {
  final localStorage = HiveServiceImpl();
  await localStorage.init();

  locator.registerSingleton<HiveService>(localStorage);
}
