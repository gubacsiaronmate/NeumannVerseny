import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80.0,
      title: const Text(
        "onTime",
        style: TextStyle(
          fontFamily: "Urbanist-SemiBold",
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          iconSize: 30.0,
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Builder(
            builder: (context) => IconButton(
              iconSize: 30.0,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.menu_rounded),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
