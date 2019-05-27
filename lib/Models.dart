import 'package:cloud_firestore/cloud_firestore.dart';

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

  bool checked;
  num tmp = 0.0;

  DutchCity(
      {this.city,
      this.admin,
      this.country,
      this.populationProper,
      this.iso2,
      this.capital,
      this.lat,
      this.lng,
      this.population,
      this.checked});

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
        checked: data['checked'] ?? false);
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
        checked: data['checked'] ?? false);
  }
}
