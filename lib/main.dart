import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// My custom classes
import 'Mapping.dart';

// Run the MaterialApp
void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          stream: FirebaseAuth.instance.onAuthStateChanged,
        )
      ],
      child: MaterialApp(
        title: "Weather app",
        theme: ThemeData(
            primarySwatch: Colors.pink), // Color of theme through out the app
        // The app starts with authenticating the user and route to the appropriate page
        home: Mapping(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
