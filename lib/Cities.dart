import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Authentication.dart';
import 'Database.dart';

import 'dart:async';

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

  factory DutchCity.fromJson(Map<String, dynamic> json) {
    return DutchCity(
      city: json['city'] as String,
      admin: json['admin'] as String,
      country: json['country'] as String,
      populationProper: json['population_proper'] as String,
      iso2: json['iso2'] as String,
      capital: json['capital'] as String,
      lat: json['lat'] as String,
      lng: json['lng'] as String,
      population: json['population'] as String,
    );
  }
}

class ListViewCities extends StatefulWidget {
  final List<DutchCity> dutchCities;

  final AuthImplementation auth;
  // A callback to method setAuthentication inside the Authentication model
  final VoidCallback setAuthentication;

  ListViewCities({this.auth, this.setAuthentication, this.dutchCities});

  State<StatefulWidget> createState() {
    return _ListViewCitiesState();
  }
}

void createFavoCity(DutchCity city) async {
  CollectionReference favoCities = await Database.collections.favoCities();
  DocumentReference favoCity = await favoCities.document(city.city);

  if (city.checked) {
    Database.databaseReference.runTransaction((Transaction tx) async {
      DocumentSnapshot snapshot = await tx.get(favoCity);
      await tx.set(favoCity, {'checked': city.checked});
    });
  } else {
    favoCity.delete();
  }
}

class _ListViewCitiesState extends State<ListViewCities> {
  final db = Firestore.instance;
  String uid;

  @override
  void initState() {
    widget.auth.getCurrentUser().then((uid) {
      setState(() {
        this.uid = uid;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db
            .collection('users')
            .document(this.uid)
            .collection('favoCity')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          widget.dutchCities.forEach((city) => {
                snapshot.data.documents.forEach((document) => {
                      if (document.documentID == city.city)
                        {city.checked = true}
                    })
              });

          return Container(
            child: ListView.builder(
              itemCount: widget.dutchCities.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${widget.dutchCities[position].city}',
                        style: TextStyle(
                            fontSize: 22.0, color: Colors.deepOrangeAccent),
                      ),
                      leading: Text((position + 1).toString() + '.'),
                      trailing: Transform.scale(
                        scale: 1.25,
                        child: Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              DutchCity city = widget.dutchCities[position];
                              city.checked = value;
                              createFavoCity(city);
                            });
                          },
                          value: widget.dutchCities[position].checked)
                        ),
                      onTap: () =>
                          _onTapItem(context, widget.dutchCities[position]),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  void _onTapItem(BuildContext context, DutchCity city) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(
            'De stad ${city.city} ligt in de provincie ${city.admin}.')));
  }
}
