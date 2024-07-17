import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  static Future<void> saveSettings({
    required bool callAfterAppOpened,
    required String? phoneNumber,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool("callAfterAppOpened", callAfterAppOpened);
    sharedPreferences.setString("phoneNumber", phoneNumber ?? "");
  }

  static Future<({bool callAfterAppOpened, String? phoneNumber})> getSettings() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final bool callAfterAppOpened = sharedPreferences.getBool("callAfterAppOpened") ?? false;
    String? phoneNumber = sharedPreferences.getString("phoneNumber") ?? "";

    if (phoneNumber.isEmpty) {
      phoneNumber = null;
    }

    return (callAfterAppOpened: callAfterAppOpened, phoneNumber: phoneNumber);
  }
}
