import 'package:on_time/common/common.dart';
import 'package:on_time/router/router.dart';
import 'package:on_time/screens/fade_animationtest.dart';
import 'package:on_time/widgets/custom_widget.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFE8ECF4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInAnimation(
                delay: 1,
                child: IconButton(
                    onPressed: () {
                      GoRouter.of(context)
                          .pushNamed(Routers.authenticationpage.name);
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
                      delay: 1.3,
                      child: Text(
                        "Üdvözöljük!",
                        style: Common().titelTheme,
                      ),
                    ),
                    FadeInAnimation(
                      delay: 1.6,
                      child: Text(
                        "Örülünk, hogy újra láthatjuk!",
                        style: Common().titelTheme,
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
                        delay: 1.9,
                        child: CustomTextFormField(
                          hinttext: 'Adja meg e-mail címet',
                          obsecuretext: false,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        delay: 2.2,
                        child: TextFormField(
                          obscureText: flag ? true : false,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(18),
                              hintText: "Adja meg jelszavát",
                              hintStyle: Common().hinttext,
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(12)),
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.remove_red_eye_outlined))),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        delay: 2.5,
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
                                ))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInAnimation(
                        delay: 2.8,
                        child: CustomElevatedButton(
                          message: "Bejelentkezés",
                          function: () {
                            if (flag) {
                              setState(() {
                                flag = false;
                              });
                            } else {
                              setState(() {
                                flag = true;
                              });
                            }
                          },
                          color: Colors.black,
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
                        delay: 2.2,
                        child: Text(
                          "vagy jelentkezzen be ezzel",
                          style: Common().semiboldblack,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInAnimation(
                        delay: 2.4,
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
                delay: 2.8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Nincs még fiókja?",
                        style: Common().hinttext,
                      ),
                      TextButton(
                          onPressed: () {
                            GoRouter.of(context)
                                .pushNamed(Routers.signuppage.name);
                          },
                          child: Text(
                            "Regisztráljon most!",
                            style: Common().mediumTheme,
                          )),
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
