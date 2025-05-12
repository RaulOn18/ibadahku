import 'dart:developer';

import 'package:get_storage/get_storage.dart';

class AppStorage {
  static initialise() async {
    try {
      await GetStorage.init();
    } catch (e, stackTrace) {
      log("Error when initialising GetStorage: $e $stackTrace");
    }
  }

  final GetStorage getStorage = GetStorage();

  void set(String key, dynamic value) => getStorage.write(key, value);

  dynamic get(String key) => getStorage.read(key);
}
