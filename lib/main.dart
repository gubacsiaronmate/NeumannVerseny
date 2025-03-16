import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:on_time/providers/theme_provider.dart';
import 'package:on_time/router/router_config.dart';
import 'package:on_time/common/common.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'common/functions.dart';
import 'models/notification_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NotificationModelAdapter());
  await Hive.openBox<NotificationModel>("notifications");

  final notifsBox = Hive.box<NotificationModel>('notifications');
  if (notifsBox.isEmpty) {
    addSampleNotifications(notifsBox);
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      theme: Common.lightTheme,
      darkTheme: Common.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
    );
  }
}