import 'package:flutter/material.dart';

// My custom classes
import 'Mapping.dart';
import 'Authentication.dart';

// Run the MaterialApp
void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather app",
      theme: ThemeData(primarySwatch: Colors.pink), // Color of theme through out the app
      // The app starts with authenticating the user and route to the appropriate page
      home: Mapping(auth: Authentication()),
      debugShowCheckedModeBanner: false,
    );
  }
}