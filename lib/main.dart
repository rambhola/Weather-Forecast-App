import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/weather/views/weather_app.dart';

import 'features/theme/views model/theme_controller.dart';


void main() {
  Get.put(ThemeController());  // Initialize controller first
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.black,  // Black icons/text
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
        ),
      ),

      themeMode: themeController.isDarkModeValue
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const WeatherApp(),
    );
  }
}

