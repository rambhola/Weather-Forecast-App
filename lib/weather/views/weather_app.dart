import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

import '../../features/theme/views model/theme_controller.dart';
import '../../features/theme/views/setting_page.dart';


class WeatherApp extends StatefulWidget {
  static String routName = "weather app";
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late String currentDateTime;
  late String currentTime;
  Map<String, dynamic>? weatherData;
  final ThemeController themeController = Get.find();

  @override
  void initState() {
    super.initState();
    currentTime = DateFormat('hh:mm').format(DateTime.now());
    currentDateTime = DateFormat('EEE h:mm a').format(DateTime.now());
    getCurrentWeather();
    _getCurrentLocation();
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getCurrentWeather() async {
    try {
      Position position = await _getCurrentLocation();
      final response = await http.get(
        Uri.parse(
          "http://api.weatherapi.com/v1/current.json?key=42e2bb754c094958bb263805251001&q=${position.latitude},${position.longitude}&aqi=yes",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          weatherData = data;
        });
      } else {
        if (kDebugMode) {
          print("Failed to load weather details: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching weather data: $e");
      }
    }
  }

  final spinkit = SpinKitFadingCircle(color: Colors.white, size: 50.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(itemBuilder: (_) {
            return [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 11),
                    Text("Setting"),
                  ],
                ),
                onTap: () => Get.to(() => SettingPages()),
              )
            ];
          })
        ],
      ),
      body:

       Obx(() {
         themeController.isDarkModeValue;
         return weatherData == null
             ? Center(child: spinkit)
             : Padding(
           padding: const EdgeInsets.all(8.0),
           child: SingleChildScrollView(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 Center(
                   child: Text(
                     weatherData?['location']?['name'] ?? "Unknown Location",
                     style: TextStyle(
                       color: themeController.isDarkModeValue
                           ? Colors.white
                           : Colors.black87,
                       fontSize: 30,
                     ),
                   ),
                 ),
                 Center(
                   child: Text(
                     currentDateTime,
                     style: TextStyle(
                       color: themeController.isDarkModeValue
                           ? Colors.white
                           : Colors.black87,
                       fontSize: 22,
                     ),
                   ),
                 ),
                 const SizedBox(height: 20),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Padding(
                       padding: EdgeInsets.only(top: 80, left: 41, right: 10),
                       child: Lottie.asset(
                         'assets/animation/Animation - 1736767167371.json',
                         fit: BoxFit.cover,
                         width: 125,
                         height: 150,
                       ),
                     ),
                     Lottie.asset(
                       'assets/animation/Animation - 1736767167371.json',
                       fit: BoxFit.cover,
                       width: 95,
                       height: 130,
                       animate: true,
                     ),
                   ],
                 ),
                 const SizedBox(height: 20),
                 Center(
                   child: Text(
                     "${weatherData?['current']?['temp_c']}°C",
                     style: TextStyle(
                       fontSize: 47,
                       fontWeight: FontWeight.w600,
                       color: themeController.isDarkModeValue
                           ? Colors.white
                           : Colors.black87,
                     ),
                   ),
                 ),
                 Center(
                   child: Text(
                     weatherData?['current']?['is_day'] == 0
                         ? "GOOD NIGHT"
                         : "GOOD MORNING",
                     style: TextStyle(
                       color: themeController.isDarkModeValue
                           ? Colors.white
                           : Colors.black87,
                       fontSize: 17,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
                 const SizedBox(height: 20),
                 Center(
                   child: Text(
                     "WASIM",
                     style: TextStyle(
                       color: themeController.isDarkModeValue
                           ? Colors.white
                           : Colors.black87,
                       fontSize: 17,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
                 const SizedBox(height: 20),
                 Divider(
                   color: themeController.isDarkModeValue
                       ? Colors.white70
                       : Colors.black54,
                   thickness: 2,
                   indent: 150,
                   endIndent: 150,
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Column(
                       children: [
                         Lottie.asset(
                           'assets/animation/Sunset Animation.json',
                           width: 60,
                           height: 60,
                         ),
                         Text(
                           currentTime,
                           style: TextStyle(
                             color: themeController.isDarkModeValue  // ← FIXED
                                 ? Colors.white
                                 : Colors.black87,
                             fontSize: 22,
                           ),
                         ),
                         Text(
                           "SUNSET",
                           style: TextStyle(
                             color: themeController.isDarkModeValue
                                 ? Colors.white
                                 : Colors.black87,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ],
                     ),
                     Column(
                       children: [
                         Lottie.asset(
                           'assets/animation/wind_tharamometer.json',
                           width: 60,
                           height: 60,
                         ),
                         Text(
                           "${weatherData?['current']?['wind_mph']} mph",
                           style: TextStyle(
                             fontSize: 22,
                             color: themeController.isDarkModeValue
                                 ? Colors.white
                                 : Colors.black87,
                           ),
                         ),
                       ],
                     ),
                     Column(
                       children: [
                         Lottie.asset(
                           'assets/animation/Celsius.json',
                           width: 60,
                           height: 60,
                         ),
                         Text(  // ← REMOVED extra Obx() - not needed now
                           "${weatherData?['current']?['temp_c']}°C",
                           style: TextStyle(
                             fontSize: 22,
                             color: themeController.isDarkModeValue
                                 ? Colors.white
                                 : Colors.black87,
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
               ],
             ),
           ),
         );

       }



       ),

    );
  }
}
