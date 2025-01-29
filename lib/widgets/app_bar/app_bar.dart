import 'package:flutter/material.dart';
import 'package:on_time/screens/notifications/notifications_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80.0,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
      title: const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text(
          "onTime",
          style: TextStyle(
            fontFamily: "Urbanist-SemiBold",
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      centerTitle: false,
      actions: [
        _buildContainedIconButton(
          icon: Icons.notifications_none_rounded,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationScreen()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: _buildContainedIconButton(
            icon: Icons.menu_rounded,
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ],
    );
  }

  Widget _buildContainedIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: IconButton(
        iconSize: 30.0,
        splashRadius: 20,
        onPressed: onPressed,
        icon: Icon(icon),
        splashColor: Colors.grey.withOpacity(0.2),
        highlightColor: Colors.transparent,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}