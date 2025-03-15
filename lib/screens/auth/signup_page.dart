import 'package:on_time/common/common.dart';
import 'package:on_time/screens/animations/fade_animation.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:on_time/services/appwrite_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final Common common = Common();
  final AppwriteService appwriteService = AppwriteService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A jelszavak nem egyeznek!')),
        );
        return;
      }

      try {
        appwriteService.deleteSessionId();
        await appwriteService.registerUser(
          username: username,
          email: email,
          password: password,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sikeres regisztráció!')),
        );
        GoRouter.of(context).go('/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hiba történt: $e')),
        );
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
            children: [
              FadeInAnimation(
                duration: const Duration(milliseconds: 500),
                startDelay: const Duration(milliseconds: 40),
                direction: FadeInDirection.up,
                child: IconButton(
                  onPressed: () => GoRouter.of(context).pop(),
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
                      child: Text("Üdv!", style: Theme.of(context).textTheme.displayLarge),
                    ),
                    FadeInAnimation(
                      duration: const Duration(milliseconds: 750),
                      startDelay: const Duration(milliseconds: 60),
                      direction: FadeInDirection.up,
                      child: Text("A folytatáshoz regisztráljon!", style: Theme.of(context).textTheme.displayLarge),
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
                          controller: _usernameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(18),
                            hintText: 'Felhasználónév',
                            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Adjon meg egy felhasználónevet!';
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(18),
                            hintText: 'E-mail',
                            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Adjon meg egy e-mail címet!';
                            }
                            if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                              return 'Érvénytelen e-mail cím!';
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
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(18),
                            hintText: 'Jelszó',
                            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
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
                              return 'Adjon meg egy jelszót!';
                            }
                            if (value.length < 6) {
                              return 'A jelszónak legalább 6 karakter hosszúnak kell lennie!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1250),
                        startDelay: const Duration(milliseconds: 100),
                        direction: FadeInDirection.up,
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(18),
                            hintText: 'Jelszó megerősítése',
                            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                              icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Erősítse meg a jelszavát!';
                            }
                            if (value != _passwordController.text) {
                              return 'A jelszavak nem egyeznek!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1375),
                        startDelay: const Duration(milliseconds: 110),
                        direction: FadeInDirection.up,
                        child: CustomElevatedButton(
                          message: "Regisztrálás",
                          function: _register,
                          color: Theme.of(context).colorScheme.onSurface,
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
                        duration: const Duration(milliseconds: 1500),
                        startDelay: const Duration(milliseconds: 120),
                        direction: FadeInDirection.up,
                        child: Text("vagy regisztráljon ezzel", style: Theme.of(context).textTheme.titleMedium),
                      ),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1625),
                        startDelay: const Duration(milliseconds: 130),
                        direction: FadeInDirection.up,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
            ],
          ),
        ),
      ),
    );
  }
}