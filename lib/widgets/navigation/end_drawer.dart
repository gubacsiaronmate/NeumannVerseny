import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/appwrite/appwrite_service.dart';

import '../../router/router.dart';

class CustomEndDrawer extends StatelessWidget {
  const CustomEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appwriteService = AppwriteService();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black45,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Log Out'),
            onTap: () async {
              try {
                await appwriteService.logoutUser();
                Navigator.of(context).pop();
                GoRouter.of(context).replace(
                  Routers.loginpage.name,
                );
                print('User logged out!');
              } catch (e) {
                print('Error during logout: $e');
              }
            },
          )
        ],
      ),
    );
  }
}
