import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Models.dart';

// Must be a top-level method according to the documentation
List<DutchCity> parseCities(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map>();
  return parsed.map<DutchCity>((data) => DutchCity.fromMap(data)).toList();
}

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<List<DutchCity>> streamDutchCities(FirebaseUser user) {
    var ref =
        _db.collection('users').document(user.uid).collection('favoCities');

    return ref.snapshots().map((list) => list.documents
        .map((document) => DutchCity.fromFirestore(document))
        .toList());
  }
}

class HttpService {
  Future<List<DutchCity>> streamDutchCities() async {
    final response =
        await http.get('http://jsonstub.com/dutch/cities', headers: {
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
}
