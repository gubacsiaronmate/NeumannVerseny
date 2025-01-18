import 'package:on_time/router/router_config.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

void main() {
  runApp(const MyApp());

  // flutter api
  Client client = Client();
  client.setProject('678aa790002d7c50d1a8');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          primaryColor: Color(0xFF35C2C1),
          textTheme: Typography.blackCupertino),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
    );
  }
}
