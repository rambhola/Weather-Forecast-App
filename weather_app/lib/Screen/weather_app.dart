import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
       backgroundColor: Colors.black,
      body: weatherData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                weatherData?['location']?['name'] ?? "Unknown Location",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            Center(
              child: Text(
                currentDateTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80, left: 41, right: 10),
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
                style: const TextStyle(
                  fontSize: 47,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Text(
                weatherData?['current']?['is_day'] == 0
                    ? "GOOD NIGHT"
                    : "GOOD MORNING",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "WASIM",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              color: Colors.white,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    const Text(
                      "SUNSET",
                      style: TextStyle(
                        color: Colors.white,
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
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
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
                    Text(
                      "${weatherData?['current']?['temp_c']}°C",
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
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
}
