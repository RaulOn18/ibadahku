import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibadahku/screens/adzan_screen.dart';
import 'package:ibadahku/screens/dizkr_screen.dart';
import 'package:ibadahku/screens/event/views/event_detail_view.dart';
import 'package:ibadahku/screens/event/views/event_list.dart';
import 'package:ibadahku/screens/event/views/upload_bukti_kehadiran.dart';
import 'package:ibadahku/screens/forgot_password_screen.dart';
import 'package:ibadahku/screens/home_screen.dart';
import 'package:ibadahku/screens/login_screen.dart';
import 'package:ibadahku/screens/profile_screen.dart';
import 'package:ibadahku/screens/quran/quran_detail_screen.dart';
import 'package:ibadahku/screens/quran/quran_screen.dart';
import 'package:ibadahku/screens/scan_qr/views/scan_qr_view.dart';
import 'package:ibadahku/screens/sign_screen.dart';
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
  static const String event = '/event';
  static const String eventDetail = '/eventDetail';
  static const String scanQr = '/scanQr';
  static const String uploadBuktiKehadiran = '/uploadBuktiKehadiran';
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
  static const String event = Routes.event;
  static const String eventDetail = Routes.eventDetail;
  static const String scanQr = Routes.scanQr;
  static const String uploadBuktiKehadiran = Routes.uploadBuktiKehadiran;

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
    GetPage(
      name: sign,
      page: () => const SignScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
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
      page: () => const MaxWidthWrapper(child: HomeScreen()),
      transition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: adzan,
      page: () => const MaxWidthWrapper(child: AdzanScreen()),
      transition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: dizkr,
      page: () => const MaxWidthWrapper(child: DizkrScreen()),
      transition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: yaumiyah,
      page: () => const MaxWidthWrapper(child: YaumiyahScreen()),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: quran,
      page: () => const MaxWidthWrapper(child: QuranScreen()),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: quranDetail,
      page: () => const MaxWidthWrapper(child: QuranDetailScreen()),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: profile,
      page: () => const MaxWidthWrapper(child: ProfileScreen()),
      transition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    ),
    GetPage(
      name: event,
      page: () => const MaxWidthWrapper(
        child: EventListScreen(),
      ),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: eventDetail,
      page: () => const MaxWidthWrapper(
        child: EventDetailScreen(),
      ),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: scanQr,
      page: () => const MaxWidthWrapper(
        child: ScanQrScreen(),
      ),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: uploadBuktiKehadiran,
      page: () => const MaxWidthWrapper(
        child: UploadBuktiKehadiran(),
      ),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
  ];
}

class MaxWidthWrapper extends StatelessWidget {
  const MaxWidthWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      // Optional: To center the content on wider screens
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth > 768.0 ? 768.0 : double.infinity,
        ),
        child: child,
      ),
    );
  }
}
