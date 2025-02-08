import 'package:flutter/cupertino.dart';
import 'package:on_time/router/router_config.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          primaryColor: const Color(0xFF35C2C1),
          textTheme: Typography.blackCupertino),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark().copyWith(
        cupertinoOverrideTheme: const CupertinoThemeData(brightness: Brightness.dark),
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
    );
  }
}