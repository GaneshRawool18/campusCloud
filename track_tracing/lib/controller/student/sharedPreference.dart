import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceController {
  static String? id;
  static bool? isLogin;
  static Future<void> setData(
      {required bool isLogin, required String studentID}) async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    ref.setBool("isLogin", isLogin);
    ref.setString("id", studentID);
    log("Data while seting => $isLogin $studentID");
  }

  static Future<void> getData() async {
    SharedPreferences ref = await SharedPreferences.getInstance();

    id = ref.getString("id") ?? "";
    isLogin = ref.getBool("isLogin") ?? false;
    log("Data while getting => $isLogin $id");
  }
}
