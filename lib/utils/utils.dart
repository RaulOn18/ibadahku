import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Utils {
  static const kPrimaryColor = Color(0xff008eca);
  static const kPrimaryMaterialColor = MaterialColor(0xff008eca, {
    50: Color(0xff008eca),
    100: Color(0xff008eca),
    200: Color(0xff008eca),
    300: Color(0xff008eca),
    400: Color(0xff008eca),
    500: Color(0xff008eca),
    600: Color(0xff008eca),
    700: Color(0xff008eca),
    800: Color(0xff008eca),
    900: Color(0xff008eca),
  });
  static const kSecondaryColor = Color.fromARGB(255, 22, 100, 178);
  static const kWhiteColor = Colors.white;
  static final kGreyColor = Colors.grey.shade300;

  // static const kPrimaryColor = Color(0xff13A795);
  // static const kPrimaryMaterialColor = MaterialColor(0xff13A795, {
  //   50: Color(0xff13A795),
  //   100: Color(0xff13A795),
  //   200: Color(0xff13A795),
  //   300: Color(0xff13A795),
  //   400: Color(0xff13A795),
  //   500: Color(0xff13A795),
  //   600: Color(0xff13A795),
  //   700: Color(0xff13A795),
  //   800: Color(0xff13A795),
  //   900: Color(0xff13A795),
  // });
  // static const kSecondaryColor = Color(0xff159687);

  // static const kPrimaryColor = Color(0xff3421de);
  // static const kPrimaryMaterialColor = MaterialColor(0xff3421de, {
  //   50: Color(0xffebe9fc),
  //   100: Color(0xffc0baf5),
  //   200: Color(0xffa299f0),
  //   300: Color(0xff776ae9),
  //   400: Color(0xff5d4de5),
  //   500: Color(0xff3421de),
  //   600: Color(0xff211ece),
  //   700: Color(0xff25179e),
  //   800: Color(0xff1d127a),
  //   900: Color(0xff160e5d),
  // });
  // static const kSecondaryColor = Color(0xff6079f7);

  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
