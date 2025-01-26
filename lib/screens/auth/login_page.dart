import 'package:appwrite/appwrite.dart';
import 'package:on_time/common/common.dart';
import 'package:on_time/router/router.dart';
import 'package:on_time/screens/animations/fade_animation.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/appwrite/appwrite_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final Common common = Common();
  final AppwriteService appwriteService = AppwriteService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await appwriteService.loginUser(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // Navigate to the home page or show a success message
        GoRouter.of(context).pushNamed(Routers.homepage.name);
      } catch (e) {
        _showErrorDialog('Nem sikerült bejelentkezni. Ellenőrizze az adatait.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(
                      delay: 1.3,
                      child: Text(
                        "Üdvözöljük!",
                        style: common.titleTheme,
                      ),
                    ),
                    FadeInAnimation(
                      delay: 1.6,
                      child: Text(
                        "Örülünk, hogy újra láthatjuk!",
                        style: common.titleTheme,
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    FadeInAnimation(
                      delay: 1.9,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(18),
                          hintText: 'Adja meg e-mail címet',
                          hintStyle: common.hinttext,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Az e-mail cím nem lehet üres';
                          }
                          if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                            return 'Érvénytelen e-mail cím';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInAnimation(
                      delay: 2.2,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(18),
                          hintText: "Adja meg jelszavát",
                          hintStyle: common.hinttext,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'A jelszó nem lehet üres';
                          }
                          if (value.length < 6) {
                            return 'A jelszónak legalább 6 karakter hosszúnak kell lennie';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
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
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInAnimation(
                      delay: 2.8,
                      child: CustomElevatedButton(
                        message: "Bejelentkezés",
                        function: _login,
                        color: common.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              FadeInAnimation(
                delay: 2.2,
                child: Column(
                  children: [
                    Text(
                      "vagy jelentkezzen be ezzel",
                      style: common.semiboldblack,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset("assets/images/facebook_ic.svg"),
                        SvgPicture.asset("assets/images/google_ic.svg"),
                        Image.asset(
                          "assets/images/Vector.png",
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              FadeInAnimation(
                delay: 2.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
        ),
      ),
    );
  }
}