import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class DutchCity {
  final String city,
      admin,
      country,
      populationProper,
      iso2,
      capital,
      lat,
      lng,
      population;
  bool checked = false;

  DutchCity(
      {this.city,
      this.admin,
      this.country,
      this.populationProper,
      this.iso2,
      this.capital,
      this.lat,
      this.lng,
      this.population});

  factory DutchCity.fromFirestore(DocumentSnapshot document) {
    Map data = document.data;

    return DutchCity(
      city: data['city'] ?? 'default',
      admin: data['admin'] ?? 'default',
      country: data['country'] ?? 'default',
      populationProper: data['population_proper'] ?? 'default',
      iso2: data['iso2'] ?? 'default',
      capital: data['capital'] ?? 'default',
      lat: data['lat'] ?? 'default',
      lng: data['lng'] ?? 'default',
      population: data['population'] ?? 'default',
    );
  }

  factory DutchCity.fromMap(Map data) {
    return DutchCity(
      city: data['city'] ?? 'default',
      admin: data['admin'] ?? 'default',
      country: data['country'] ?? 'default',
      populationProper: data['population_proper'] ?? 'default',
      iso2: data['iso2'] ?? 'default',
      capital: data['capital'] ?? 'default',
      lat: data['lat'] ?? 'default',
      lng: data['lng'] ?? 'default',
      population: data['population'] ?? 'default',
    );
  }
}
