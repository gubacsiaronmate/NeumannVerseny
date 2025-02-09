import 'package:on_time/services/appwrite_service.dart';
import 'package:on_time/common/common.dart';
import 'package:on_time/common/email/email_service.dart';
import 'package:on_time/common/email/otp_content.dart';
import 'package:on_time/common/email/otp_generator.dart';
import 'package:on_time/router/router.dart';
import 'package:on_time/screens/animations/fade_animation.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final Common common = Common();
  final AppwriteService appwriteService = AppwriteService();
  final EmailService emailService = EmailService(
      username: "deb.devs.info@gmail.com",
      password: "" // TODO: add way to read google app password from env var or something safe
  );
  final OtpContent otpContent = OtpGenerator().getEmailContent();
  String get emailContent => otpContent.email;
  int get otpCode => otpContent.otpCode;

  void send() async => emailService.sendEmail(
      to: (await appwriteService.getUserEmail()),
      subject: "Email Verification",
      body: emailContent
  );

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
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
                        "Kétfaktoros Hitelesítés",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    FadeInAnimation(
                      duration: const Duration(milliseconds: 750),
                      startDelay: const Duration(milliseconds: 60),
                      direction: FadeInDirection.up,
                      child: Text(
                        "Írja be az ellenőrző kódot, amelyet az imént küldtünk az e-mail címére.",
                        style: Theme.of(context).textTheme.bodySmall,
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
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 875),
                        startDelay: const Duration(milliseconds: 70),
                        direction: FadeInDirection.up,
                        child: Pinput(
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          validator: (s) {
                            send();
                            return s == otpCode.toString() ? null : 'A kód hibás';
                          },
                          pinputAutovalidateMode:
                          PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          onCompleted: (pin) {
                            print(pin);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInAnimation(
                        duration: const Duration(milliseconds: 1000),
                        startDelay: const Duration(milliseconds: 80),
                        direction: FadeInDirection.up,
                        child: CustomElevatedButton(
                          message: "Megerősítés",
                          function: () {
                            GoRouter.of(context)
                                .pushNamed(Routers.newpassword.name);
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