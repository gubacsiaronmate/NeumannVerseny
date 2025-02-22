import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/common/common.dart';
import 'package:on_time/router/router.dart';
import 'package:on_time/screens/animations/fade_animation.dart';
import 'package:on_time/services/appwrite_service.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';

class AuthenticationUI extends StatefulWidget {
  const AuthenticationUI({super.key});

  @override
  _AuthenticationUIState createState() => _AuthenticationUIState();
}

class _AuthenticationUIState extends State<AuthenticationUI> {
  final Common common = Common();
  final AppwriteService appwriteService = AppwriteService();

  _AuthenticationUIState() {
    appwriteService.deleteSessionId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child:
                  SvgPicture.asset('assets/images/logo.svg'),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  FadeInAnimation(
                    duration: const Duration(milliseconds: 500), // 250 * 2.0
                    startDelay: const Duration(milliseconds: 40), // 20 * 2.0
                    direction: FadeInDirection.up,
                    distance: 30.0,
                    child: CustomElevatedButton(
                      message: "Bejelentkezés",
                      function: () {
                        GoRouter.of(context).pushNamed(Routers.loginpage.name);
                      },
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInAnimation(
                    duration: const Duration(milliseconds: 625), // 250 * 2.5
                    startDelay: const Duration(milliseconds: 50), // 20 * 2.5
                    direction: FadeInDirection.up,
                    distance: 30.0,
                    child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).pushNamed(Routers.signuppage.name);
                      },
                      style: ButtonStyle(
                        side: WidgetStatePropertyAll(
                          BorderSide(color: Theme.of(context).colorScheme.onSurface),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        fixedSize: const WidgetStatePropertyAll(
                          Size.fromWidth(370),
                        ),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 20),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      child: Text(
                        "Regisztráció",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}