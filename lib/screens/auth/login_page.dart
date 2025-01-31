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
        await AppwriteService().loginUser(
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
                duration: const Duration(milliseconds: 500),
                startDelay: const Duration(milliseconds: 40),
                direction: FadeInDirection.up,
                child: IconButton(
                  onPressed: () => GoRouter.of(context).pushNamed(Routers.authenticationpage.name),
                  icon: const Icon(CupertinoIcons.back, size: 35),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(
                      duration: const Duration(milliseconds: 625),
                      startDelay: const Duration(milliseconds: 50),
                      direction: FadeInDirection.up,
                      child: Text("Üdvözöljük!", style: common.titleTheme),
                    ),
                    FadeInAnimation(
                      duration: const Duration(milliseconds: 750),
                      startDelay: const Duration(milliseconds: 60),
                      direction: FadeInDirection.up,
                      child: Text("Örülünk, hogy újra láthatjuk!", style: common.titleTheme),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 875),
                        startDelay: const Duration(milliseconds: 70),
                        direction: FadeInDirection.up,
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(18),
                            hintText: 'Adja meg e-mail címet',
                            hintStyle: common.hinttext,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                          ),
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
                        duration: const Duration(milliseconds: 1000),
                        startDelay: const Duration(milliseconds: 80),
                        direction: FadeInDirection.up,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(18),
                            hintText: "Adja meg jelszavát",
                            hintStyle: common.hinttext,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
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
                        duration: const Duration(milliseconds: 1125),
                        startDelay: const Duration(milliseconds: 90),
                        direction: FadeInDirection.up,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => GoRouter.of(context).pushNamed(Routers.forgetpassword.name),
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
                        duration: const Duration(milliseconds: 1250),
                        startDelay: const Duration(milliseconds: 100),
                        direction: FadeInDirection.up,
                        child: CustomElevatedButton(
                          message: "Bejelentkezés",
                          function: _login,
                          color: common.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Column(
                    children: [
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1375),
                        startDelay: const Duration(milliseconds: 110),
                        direction: FadeInDirection.up,
                        child: Text("vagy jelentkezzen be ezzel", style: common.semiboldblack),
                      ),
                      const SizedBox(height: 20),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1500),
                        startDelay: const Duration(milliseconds: 120),
                        direction: FadeInDirection.up,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset("assets/images/facebook_ic.svg"),
                              SvgPicture.asset("assets/images/google_ic.svg"),
                              Image.asset("assets/images/Vector.png", color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FadeInAnimation(
                duration: const Duration(milliseconds: 1625),
                startDelay: const Duration(milliseconds: 130),
                direction: FadeInDirection.up,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Nincs még fiókja?", style: common.hinttext),
                    TextButton(
                      onPressed: () => GoRouter.of(context).pushNamed(Routers.signuppage.name),
                      child: Text("Regisztráljon most!", style: common.mediumTheme),
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