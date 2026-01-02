
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  bool get isDarkModeValue => isDarkMode.value;

  void toggleTheme() {
    isDarkMode.toggle();
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
