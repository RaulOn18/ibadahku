import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/screens/adzan_screen.dart';
import 'package:ibadahku/screens/dizkr_screen.dart';
import 'package:ibadahku/screens/forgot_password_screen.dart';
import 'package:ibadahku/screens/home_screen.dart';
import 'package:ibadahku/screens/login_screen.dart';
import 'package:ibadahku/screens/profile_screen.dart';
import 'package:ibadahku/screens/quran/quran_detail_screen.dart';
import 'package:ibadahku/screens/quran/quran_screen.dart';
import 'package:ibadahku/screens/splash_screen.dart';
import 'package:ibadahku/screens/yaumiyah_screen.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String sign = '/sign';
  static const String home = '/home';
  static const String adzan = '/adzan';
  static const String quran = '/quran';
  static const String quranDetail = '/quranDetail';
  static const String yaumiyah = '/yaumiyah';
  static const String dizkr = '/dizkr';
  static const String verification = '/verification';
  static const String forgotPassword = '/forgotPassword';
  static const String searchCity = '/searchCity';
  static const String profile = '/profile';
}

class Pages {
  static const String splash = Routes.splash;
  static const String login = Routes.login;
  static const String sign = Routes.sign;
  static const String home = Routes.home;
  static const String adzan = Routes.adzan;
  static const String quran = Routes.quran;
  static const String quranDetail = Routes.quranDetail;
  static const String yaumiyah = Routes.yaumiyah;
  static const String dizkr = Routes.dizkr;
  static const String verification = Routes.verification;
  static const String forgotPassword = Routes.forgotPassword;
  static const String searchCity = Routes.searchCity;
  static const String profile = Routes.profile;

  static List<GetPage> all = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transitionDuration: const Duration(seconds: 1),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.upToDown,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    // GetPage(
    //   name: sign,
    //   page: () => const SignView(),
    //   transition: Transition.downToUp,
    //   transitionDuration: const Duration(milliseconds: 500),
    //   curve: Curves.fastLinearToSlowEaseIn,
    // ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    // GetPage(
    //   name: verification,
    //   page: () => const VerificationEmailView(),
    //   transition: Transition.downToUp,
    //   transitionDuration: const Duration(milliseconds: 500),
    //   curve: Curves.fastLinearToSlowEaseIn,
    // ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      transition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: adzan,
      page: () => const AdzanScreen(),
      transition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: dizkr,
      page: () => const DizkrScreen(),
      transition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: yaumiyah,
      page: () => const YaumiyahScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: quran,
      page: () => const QuranScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: quranDetail,
      page: () => const QuranDetailScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      transition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    // GetPage(
    //   name: search,
    //   page: () => const SearchView(),
    //   transition: Transition.upToDown,
    //   transitionDuration: const Duration(milliseconds: 200),
    //   curve: Curves.fastLinearToSlowEaseIn,
    // ),
  ];
}
