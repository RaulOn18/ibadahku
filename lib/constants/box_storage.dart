import 'package:get_storage/get_storage.dart';

class BoxStorage {
  void init() {
    GetStorage.init();
  }

  void save(String key, dynamic value) {
    GetStorage().write(key, value);
  }

  dynamic get(String key) {
    return GetStorage().read(key);
  }
}
