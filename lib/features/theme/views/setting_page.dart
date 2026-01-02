import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views model/theme_controller.dart';


class SettingPages extends StatelessWidget {
  final ThemeController themeController = Get.find();

  SettingPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Setting")),
      body: Obx(() => SwitchListTile.adaptive(
        title: Text("Light Theme"),
        subtitle: Text("Change Theme"),
        value: !themeController.isDarkMode.value,
        onChanged: (_) => themeController.toggleTheme(),
      )),
    );
  }
}





