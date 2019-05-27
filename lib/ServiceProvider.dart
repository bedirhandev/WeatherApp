import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import 'Models.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  get db => _db;
}

class HttpService {
  Stream<DutchCity> parseCities(String responseBody) async* {
    final parsed = json.decode(responseBody).cast<Map>();
    for (var data in parsed) yield DutchCity.fromMap(data);
  }

  Stream<DutchCity> fetchDutchCities() async* {
    final response =
        await http.get('http://jsonstub.com/dutch/cities', headers: {
      'Content-Type': 'application/json',
      'JsonStub-User-Key': 'a911577f-8bb7-434c-85f6-9f84d1208fcb',
      'JsonStub-Project-Key': '95d93efe-ee40-4d05-b689-6a66800afd8e'
    });

    if (response.statusCode == 200) {
      await for (var city in parseCities(response.body)) yield city;
    } else {
      throw Exception('Failed to load cities');
    }
  }
}

void fetchWeatherForCity(DutchCity _city) async {
  var name = _city.city.replaceAll(RegExp(r'[^A-Za-z0-9- ]'), "");

  final response = await http.get(
      'https://api.openweathermap.org/data/2.5/weather?q=${name},nl&appid=df62b4576b8809f0ca5082fb6555c908&units=metric',
      headers: {
        'Content-Type': 'application/json',
      });

  if (response.statusCode == 200) {
    String responseBody = response.body;
    _city.tmp = json.decode(responseBody)['main']['temp'];
  } else {
    throw Exception('Failed to load cities');
  }
}

class DutchCities with ChangeNotifier {
  final httpService = HttpService();
  final dbService = DatabaseService();

  final _cities = List<DutchCity>();
  final _favoCities = List<DutchCity>();

  get cities => _cities;
  get favoCities => _favoCities;

 //StreamSubscription subscription;

  void setFavoCity(
      int index, String name, bool value, FirebaseUser user) async {
    CollectionReference collectionFavoCities = await dbService.db
        .collection('users')
        .document(user.uid)
        .collection('favoCities');
    DocumentReference favoCity = collectionFavoCities.document(name);

    cities[index].checked = value;

    if (value) {
      await fetchWeatherForCity(cities[index]);
      favoCities.add(cities[index]);

      dbService.db.runTransaction((Transaction tx) async {
        await tx.set(favoCity, {'id': index, 'checked': value});
      });

      notifyListeners();
    } else {
      favoCities.remove(cities[index]);
      favoCity.delete();
      notifyListeners();
    }
  }

  void updateFromDatabase(FirebaseUser user) async {
    CollectionReference favoCities = await dbService.db
        .collection('users')
        .document(user.uid)
        .collection('favoCities');

    await for (var snapshot in favoCities.snapshots()) {
      for (var document in snapshot.documents) {
        var index = document.data['id'];
        bool checked = document.data['checked'];

        _cities[index].checked = checked;
        await fetchWeatherForCity(_cities[index]);

        if (_favoCities.contains(_cities[index])) {
          index = _favoCities.indexOf(_cities[index]);
          _favoCities[index].checked = checked;
        } else {
          _favoCities.add(_cities[index]);
        }

        notifyListeners();
      }
    }

    /*if(subscription == null) {
      subscription = favoCities.snapshots().listen((snapshot) {
        snapshot.documentChanges.forEach((change) {
          var index = change.document.data['id'];
          bool checked = change.document.data['checked'];

          _cities[index].checked = checked;

          if(_favoCities.contains(_cities[index])) {
            index = _favoCities.indexOf(_cities[index]);
            _favoCities[index].checked = checked;
          }

          if (change.type == DocumentChangeType.added) {
            print('New city:  ${change.document.data}');

            _cities[index].checked = checked;
            _favoCities.add(_cities[index]);

            notifyListeners();
          }

          if (change.type == DocumentChangeType.modified) {
            print('Modified city:  ${change.document.data}');
          }

          if (change.type == DocumentChangeType.removed) {
            print('Removed city:  ${change.document.data}');

            _cities[index].checked = !value;
            // Maybe before the above one?
            _favoCities.remove(_cities[index]);
            notifyListeners();
          }
        });
      });

    } else {
      subscription.resume();
    }*/
  }

  // use this when the user goes out of screen
  /*void dispose() {
    subscription.pause();
  }*/

  void initialise(FirebaseUser user) async {
    if(_cities.length == 0) {
      await fetchCities(user);
      await updateFromDatabase(user);
    }
  }

  void fetchCities(FirebaseUser user) async {
    await for (var city in httpService.fetchDutchCities()) {
      _cities.add(city);

      notifyListeners();
    }
  }
}