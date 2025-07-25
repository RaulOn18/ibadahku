import 'package:get_storage/get_storage.dart';

class BoxStorage {
  Future<void> save(String key, dynamic value) async {
    await GetStorage().write(key, value);
  }

  Future<dynamic> get(String key) async {
    return await GetStorage().read(key);
  }
}
