import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/common/common.dart';
import 'package:on_time/router/router.dart';
import 'package:on_time/screens/fade_animationtest.dart';
import 'package:on_time/widgets/custom_widget.dart';

class AuthenticationUI extends StatefulWidget {
  const AuthenticationUI({super.key});

  @override
  _AuthenticationUIState createState() => _AuthenticationUIState();
}

class _AuthenticationUIState extends State<AuthenticationUI> {
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
              child: const Center(
                child:
                  Image(image: AssetImage('assets/images/logo-placeholder-image.png'),
                /*LottieBuilder.asset(
                  "assets/images/logo.json",
                  repeat: false,
                  onLoaded: (composition) {
                    debugPrint('Animation Loaded');
                  },*/
                ),
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
                    delay: 2,
                    child: CustomElevatedButton(
                      message: "Bejelentkezés",
                      function: () {
                        GoRouter.of(context).pushNamed(Routers.loginpage.name);
                      },
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInAnimation(
                    delay: 2.5,
                    child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).pushNamed(Routers.signuppage.name);
                      },
                      style: ButtonStyle(
                        side: const MaterialStatePropertyAll(
                          BorderSide(color: Colors.black),
                        ),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        fixedSize: const MaterialStatePropertyAll(
                          Size.fromWidth(370),
                        ),
                        padding: const MaterialStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 20),
                        ),
                        backgroundColor: const MaterialStatePropertyAll(
                          Colors.white,
                        ),
                      ),
                      child: const Text(
                        "Regisztráció",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Urbanist-SemiBold",
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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