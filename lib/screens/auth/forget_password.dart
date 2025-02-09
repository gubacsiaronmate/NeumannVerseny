import 'package:on_time/common/common.dart';
import 'package:on_time/router/router.dart';
import 'package:on_time/screens/animations/fade_animation.dart';
import 'package:on_time/widgets/forms/custom_text_form_field.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final Common common = Common();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInAnimation(
                duration: const Duration(milliseconds: 250), // 250 * 1
                startDelay: const Duration(milliseconds: 20), // 20 * 1
                direction: FadeInDirection.up,
                child: IconButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  icon: const Icon(
                    CupertinoIcons.back,
                    size: 35,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(
                      duration: const Duration(milliseconds: 325), // 250 * 1.3
                      startDelay: const Duration(milliseconds: 26), // 20 * 1.3
                      direction: FadeInDirection.up,
                      child: Text(
                        "Elfelejtette jelszavát?",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    FadeInAnimation(
                      duration: const Duration(milliseconds: 400), // 250 * 1.6
                      startDelay: const Duration(milliseconds: 32), // 20 * 1.6
                      direction: FadeInDirection.up,
                      child: Text(
                        "Kérjük, adja meg a fiókjához tartozó e-mail címet.",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  child: Column(
                    children: [
                      const FadeInAnimation(
                        duration: Duration(milliseconds: 475), // 250 * 1.9
                        startDelay: Duration(milliseconds: 38), // 20 * 1.9
                        direction: FadeInDirection.up,
                        child: CustomTextFormField(
                          hinttext: 'Adja meg e-mail címet',
                          obsecuretext: false,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 525), // 250 * 2.1
                        startDelay: const Duration(milliseconds: 42), // 20 * 2.1
                        direction: FadeInDirection.up,
                        child: CustomElevatedButton(
                          message: "Kód elküldése",
                          function: () {
                            GoRouter.of(context)
                                .pushNamed(Routers.otpverification.name);
                          },
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              FadeInAnimation(
                duration: const Duration(milliseconds: 600), // 250 * 2.4
                startDelay: const Duration(milliseconds: 48), // 20 * 2.4
                direction: FadeInDirection.up,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account?",
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
                      ),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context)
                              .pushNamed(Routers.signuppage.name);
                        },
                        child: Text(
                          "Register Now",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}