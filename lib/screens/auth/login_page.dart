import 'package:on_time/common/common.dart';
import 'package:on_time/router/router.dart';
import 'package:on_time/screens/animations/fade_animation.dart';
import 'package:on_time/widgets/forms/custom_text_form_field.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool flag = true;
  final Common common = Common();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInAnimation(
                duration: const Duration(milliseconds: 500),
                startDelay: const Duration(milliseconds: 40),
                direction: FadeInDirection.up,
                child: IconButton(
                  onPressed: () {
                    GoRouter.of(context)
                        .pushNamed(Routers.authenticationpage.name);
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
                      duration: const Duration(milliseconds: 625),
                      startDelay: const Duration(milliseconds: 50),
                      direction: FadeInDirection.up,
                      child: Text(
                        "Üdvözöljük!",
                        style: common.titleTheme,
                      ),
                    ),
                    FadeInAnimation(
                      duration: const Duration(milliseconds: 750),
                      startDelay: const Duration(milliseconds: 60),
                      direction: FadeInDirection.up,
                      child: Text(
                        "Örülünk, hogy újra láthatjuk!",
                        style: common.titleTheme,
                      ),
                    ),
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
                          hinttext: 'Adja meg e-mail címet',
                          obsecuretext: false,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1000),
                        startDelay: const Duration(milliseconds: 80),
                        direction: FadeInDirection.up,
                        child: TextFormField(
                          obscureText: flag ? true : false,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(18),
                            hintText: "Adja meg jelszavát",
                            hintStyle: common.hinttext,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.remove_red_eye_outlined),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1125),
                        startDelay: const Duration(milliseconds: 90),
                        direction: FadeInDirection.up,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context)
                                  .pushNamed(Routers.forgetpassword.name);
                            },
                            child: const Text(
                              "Elfelejtette jelszavát?",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Urbanist-SemiBold",
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1250),
                        startDelay: const Duration(milliseconds: 100),
                        direction: FadeInDirection.up,
                        child: CustomElevatedButton(
                          message: "Bejelentkezés",
                          function: () {
                            GoRouter.of(context)
                                .pushNamed(Routers.homepage.name);
                          },
                          color: common.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Column(
                    children: [
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1375),
                        startDelay: const Duration(milliseconds: 110),
                        direction: FadeInDirection.up,
                        child: Text(
                          "vagy jelentkezzen be ezzel",
                          style: common.semiboldblack,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1500),
                        startDelay: const Duration(milliseconds: 120),
                        direction: FadeInDirection.up,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 30, left: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                  "assets/images/facebook_ic (1).svg"),
                              SvgPicture.asset("assets/images/google_ic-1.svg"),
                              Image.asset(
                                "assets/images/Vector.png",
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FadeInAnimation(
                duration: const Duration(milliseconds: 1625),
                startDelay: const Duration(milliseconds: 130),
                direction: FadeInDirection.up,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Nincs még fiókja?",
                        style: common.hinttext,
                      ),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context)
                              .pushNamed(Routers.signuppage.name);
                        },
                        child: Text(
                          "Regisztráljon most!",
                          style: common.mediumTheme,
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