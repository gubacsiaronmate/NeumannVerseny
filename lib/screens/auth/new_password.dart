import 'package:on_time/common/common.dart';
import 'package:on_time/router/router.dart';
import 'package:on_time/screens/animations/fade_animation.dart';
import 'package:on_time/widgets/forms/custom_text_form_field.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final Common common = Common();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFE8ECF4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInAnimation(
                duration: const Duration(milliseconds: 500),
                startDelay: const Duration(milliseconds: 40),
                direction: FadeInDirection.up,
                child: IconButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      size: 35,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(
                      duration: const Duration(milliseconds: 625),
                      startDelay: const Duration(milliseconds: 50),
                      direction: FadeInDirection.up,
                      child: Text(
                        "Új jelszó létrehozása",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    FadeInAnimation(
                      duration: const Duration(milliseconds: 750),
                      startDelay: const Duration(milliseconds: 60),
                      direction: FadeInDirection.up,
                      child: Text(
                        "Az új jelszónak eltérőnek kell lennie az előző jelszótól.",
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
                        duration: Duration(milliseconds: 875),
                        startDelay: Duration(milliseconds: 70),
                        direction: FadeInDirection.up,
                        child: CustomTextFormField(
                          hinttext: 'Új jelszó',
                          obsecuretext: false,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const FadeInAnimation(
                        duration: Duration(milliseconds: 1000),
                        startDelay: Duration(milliseconds: 80),
                        direction: FadeInDirection.up,
                        child: CustomTextFormField(
                          hinttext: 'Jelszó megerősítése',
                          obsecuretext: false,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1125),
                        startDelay: const Duration(milliseconds: 90),
                        direction: FadeInDirection.up,
                        child: CustomElevatedButton(
                          message: "Jelszó helyreállítása",
                          function: () {
                            GoRouter.of(context)
                                .pushNamed(Routers.passwordchanges.name);
                          },
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}