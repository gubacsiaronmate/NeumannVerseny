import 'package:on_time/services/appwrite_service.dart';
import 'package:on_time/router/router.dart';
import 'package:on_time/screens/auth/authentication_ui.dart';
import 'package:on_time/screens/auth/forget_password.dart';
import 'package:on_time/screens/home_page.dart';
import 'package:on_time/screens/auth/login_page.dart';
import 'package:on_time/screens/auth/new_password.dart';
import 'package:on_time/screens/auth/otp_verification.dart';
import 'package:on_time/screens/auth/password_changed.dart';
import 'package:on_time/screens/auth/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

// final AppwriteService _appwriteService = AppwriteService();

final router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) async {
    final appwriteService = AppwriteService();
    final bool isLoggedIn = await appwriteService.hasActiveSession();

    if ((state.matchedLocation == Routers.loginpage.path
        || state.matchedLocation == Routers.authenticationpage.path
        || state.matchedLocation == Routers.signuppage.path) && isLoggedIn) {
      return Routers.homepage.path;
    }

    if (!isLoggedIn && state.matchedLocation != Routers.loginpage.path
        && state.matchedLocation != Routers.authenticationpage.path
        && state.matchedLocation != Routers.signuppage.path) {
      return Routers.loginpage.path;
    }

    return null;
  },

  routes: [
    GoRoute(
      path: Routers.authenticationpage.path,
      name: Routers.authenticationpage.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: AuthenticationUI());
      },
    ),
    GoRoute(
      path: Routers.loginpage.path,
      name: Routers.loginpage.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: LoginPage());
      },
    ),
    GoRoute(
      path: Routers.homepage.path,
      name: Routers.homepage.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: HomePage());
      },
    ),
    GoRoute(
      path: Routers.signuppage.path,
      name: Routers.signuppage.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: SignupPage());
      },
    ),
    GoRoute(
      path: Routers.forgetpassword.path,
      name: Routers.forgetpassword.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: ForgetPasswordPage());
      },
    ),
    GoRoute(
      path: Routers.newpassword.path,
      name: Routers.newpassword.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: NewPasswordPage());
      },
    ),
    GoRoute(
      path: Routers.otpverification.path,
      name: Routers.otpverification.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: OtpVerificationPage());
      },
    ),
    GoRoute(
      path: Routers.passwordchanges.path,
      name: Routers.passwordchanges.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: PasswordChangesPage());
      },
    ),
  ],
);