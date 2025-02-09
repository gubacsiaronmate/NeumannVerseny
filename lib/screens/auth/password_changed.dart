import 'package:on_time/common/common.dart';
import 'package:on_time/router/router.dart';
import 'package:on_time/screens/animations/fade_animation.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';
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
              duration: const Duration(milliseconds: 500),
              startDelay: const Duration(milliseconds: 40),
              direction: FadeInDirection.up,
              child: Text(
                "Jelszó megváltoztatva!",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            FadeInAnimation(
              duration: const Duration(milliseconds: 625),
              startDelay: const Duration(milliseconds: 50),
              direction: FadeInDirection.up,
              child: Text(
                "Jelszavát sikeresen megváltoztattuk",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            FadeInAnimation(
              duration: const Duration(milliseconds: 750),
              startDelay: const Duration(milliseconds: 60),
              direction: FadeInDirection.up,
              child: CustomElevatedButton(
                message: "Vissza a bejelentkezéshez",
                function: () {
                  GoRouter.of(context).pushReplacement(Routers.loginpage.name);
                },
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}