import 'package:on_time/common/common.dart';
import 'package:on_time/screens/animations/fade_animation.dart';
import 'package:on_time/widgets/forms/custom_text_form_field.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final Common common = Common();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(232, 236, 244, 1),
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
                      duration: const Duration(milliseconds: 625),
                      startDelay: const Duration(milliseconds: 50),
                      direction: FadeInDirection.up,
                      child: Text(
                        "Üdv!",
                        style: common.titleTheme,
                      ),
                    ),
                    FadeInAnimation(
                      duration: const Duration(milliseconds: 750),
                      startDelay: const Duration(milliseconds: 60),
                      direction: FadeInDirection.up,
                      child: Text(
                        "A folytatáshoz regisztráljon!",
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
                          hinttext: 'Felhasználónév',
                          obsecuretext: false,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const FadeInAnimation(
                        duration: Duration(milliseconds: 1000),
                        startDelay: Duration(milliseconds: 80),
                        direction: FadeInDirection.up,
                        child: CustomTextFormField(
                          hinttext: 'E-mail',
                          obsecuretext: false,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const FadeInAnimation(
                        duration: Duration(milliseconds: 1125),
                        startDelay: Duration(milliseconds: 90),
                        direction: FadeInDirection.up,
                        child: CustomTextFormField(
                          hinttext: 'Jelszó',
                          obsecuretext: true,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const FadeInAnimation(
                        duration: Duration(milliseconds: 1250),
                        startDelay: Duration(milliseconds: 100),
                        direction: FadeInDirection.up,
                        child: CustomTextFormField(
                          hinttext: 'Jelszó megerősítése',
                          obsecuretext: false,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1375),
                        startDelay: const Duration(milliseconds: 110),
                        direction: FadeInDirection.up,
                        child: CustomElevatedButton(
                          message: "Regisztrálás",
                          function: () {},
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
                  height: 160,
                  width: double.infinity,
                  child: Column(
                    children: [
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1500),
                        startDelay: const Duration(milliseconds: 120),
                        direction: FadeInDirection.up,
                        child: Text(
                          "vagy regisztráljon ezzel",
                          style: common.semiboldblack,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1625),
                        startDelay: const Duration(milliseconds: 130),
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
            ],
          ),
        ),
      ),
    );
  }
}