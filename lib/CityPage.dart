import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'Cities.dart';
import 'Authentication.dart';

List<DutchCity> parseCities(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<DutchCity>((json) => DutchCity.fromJson(json)).toList();
}

Future<List<DutchCity>> fetchCities(http.Client client) async {
  final response = await client.get(
    'http://jsonstub.com/dutch/cities',
    headers: {
      'Content-Type': 'application/json',
      'JsonStub-User-Key': 'a911577f-8bb7-434c-85f6-9f84d1208fcb',
      'JsonStub-Project-Key': '95d93efe-ee40-4d05-b689-6a66800afd8e'
    }
  );

  if(response.statusCode == 200) {
    return compute(parseCities, response.body);
  } else {
    throw Exception('Failed to load cities');
  }
}

class CityPage extends StatefulWidget {
  final AuthImplementation auth;
  // A callback to method setAuthentication inside the Authentication model
  final VoidCallback setAuthentication;

  CityPage({this.auth, this.setAuthentication});

  State<StatefulWidget> createState() {
    return _CityPageState();
  }
}

class _CityPageState extends State<CityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nederlandse steden"),
      ),
      body: FutureBuilder<List<DutchCity>>(
        future: fetchCities(http.Client()),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            print(snapshot.error);
          }

          if(snapshot.hasData) {
            return ListViewCities(auth: widget.auth, setAuthentication: widget.setAuthentication, dutchCities: snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}