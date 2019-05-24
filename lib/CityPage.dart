import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'Models.dart';
import 'Cities.dart';
import 'ServiceProvider.dart';

class CityPage extends StatefulWidget {
  CityPage();

  State<StatefulWidget> createState() {
    return _CityPageState();
  }
}

List<DutchCity> parseCities(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map>();
  return parsed.map<DutchCity>((data) => DutchCity.fromMap(data)).toList();
}

Future<List<DutchCity>> streamDutchCities() async {
  final response = await http.get('http://jsonstub.com/dutch/cities', headers: {
    'Content-Type': 'application/json',
    'JsonStub-User-Key': 'a911577f-8bb7-434c-85f6-9f84d1208fcb',
    'JsonStub-Project-Key': '95d93efe-ee40-4d05-b689-6a66800afd8e'
  });

  if (response.statusCode == 200) {
    return compute(parseCities, response.body);
  } else {
    throw Exception('Failed to load cities');
  }
}

class _CityPageState extends State<CityPage> {
  HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nederlandse steden"),
      ),
      body: StreamProvider<List<DutchCity>>.value(
        // All children will have access to SuperHero data
        stream: Stream.fromFuture(httpService.streamDutchCities()),
        child: Consumer<List<DutchCity>>(builder: (context, cities, child) {
          if(cities != null) {
            return ListViewCities();
          } else {
            return Center(child: CircularProgressIndicator())
          }
        }),
      ),
    );
  }
}
