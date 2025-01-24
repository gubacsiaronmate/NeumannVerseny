import 'package:on_time/common/common.dart';
import 'package:on_time/router/router.dart';
import 'package:on_time/screens/fade_animationtest.dart';
import 'package:on_time/widgets/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class PasswordChangesPage extends StatefulWidget {
  const PasswordChangesPage({super.key});

  @override
  State<PasswordChangesPage> createState() => _PasswordChangesPageState();
}

class _PasswordChangesPageState extends State<PasswordChangesPage> {
  final Common common = Common();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LottieBuilder.asset(
              "assets/images/ticker.json",
              repeat: false,
              onLoaded: (composition) {
                debugPrint('Animation Loaded');
              },
            ),
            FadeInAnimation(
              delay: 1,
              child: Text(
                "Jelszó megváltoztatva!",
                style: common.titelTheme,
              ),
            ),
            FadeInAnimation(
              delay: 1.5,
              child: Text(
                "Jelszavát sikeresen megváltoztattuk",
                style: common.mediumThemeblack,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            FadeInAnimation(
              delay: 2,
              child: CustomElevatedButton(
                message: "Vissza a bejelentkezéshez",
                function: () {
                  GoRouter.of(context).pushReplacement(Routers.loginpage.name);
                },
                color: common.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
